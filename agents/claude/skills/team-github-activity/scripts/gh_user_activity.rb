#!/usr/bin/env ruby
# frozen_string_literal: true

# Deterministically surface a GitHub user's activity in a repo over a fixed window.
#
# Pulls, for [since, until]:
#   - PRs opened, merged, and closed-without-merge (GitHub search range qualifiers)
#   - Reviews submitted by the user (exact submitted_at, filtered to the window)
#   - Issue/PR comments left by the user (exact created_at)
#   - Commits authored by the user across ALL branches (catches un-PR'd / draft work)
#
# Determinism: the window is supplied explicitly (no reliance on "now"), every
# query uses bounded date ranges, and all output is sorted by stable keys. Re-running
# with the same arguments against the same repo state yields byte-identical output.
#
# Requirements: `gh` (authenticated), `git` (repo checked out & fetched), Ruby 3.x.
#
# Usage:
#   # Absolute window (fully deterministic — preferred for reproducible reports):
#   gh_user_activity.rb --user pelted --since 2026-06-11 --until 2026-06-25 \
#     [--repo kolide/k2] [--email chris@kolide.co] [--email other@x.com] [--json]
#
#   # Relative window (convenience — anchored to today, so NOT reproducible later):
#   gh_user_activity.rb --user pelted --last 2w --email chris@kolide.co
#
# Window selection:
#   - Provide EITHER --last DURATION, OR --since (with optional --until).
#   - --last DURATION accepts Nd / Nw / Nm (days / weeks / months), e.g. 10d, 2w, 1m.
#     It sets until = today (UTC) and since = today - DURATION. The resolved absolute
#     dates are printed in the report header, so you can re-run them deterministically.
#   - --since alone defaults --until to today (UTC).
#
# Notes:
#   - --since is inclusive; --until is inclusive (end-of-day in UTC for timestamp filters).
#   - Commit detection needs local history: run `git fetch --all` first so all remote
#     branches are present. Pass --email for each address the user commits under;
#     if omitted, commit scanning is skipped (login != git email).
#
# Exit codes:
#   0  success
#   1  usage / argument error, or a non-rate-limit command failure
#   2  GitHub API rate limit exceeded (stderr contains "rate limit") — caller may
#      back off and retry. The orchestrator (gh_team_activity.rb) relies on this.

require "json"
require "date"
require "optparse"
require "open3"
require "set"

RATE_LIMIT_EXIT = 2

opts = {repo: "kolide/k2", emails: [], json: false}
OptionParser.new do |o|
  o.banner = "Usage: gh_user_activity.rb --user LOGIN --since YYYY-MM-DD --until YYYY-MM-DD [options]"
  o.on("--user LOGIN")  { |v| opts[:user]  = v }
  o.on("--repo ORG/REPO") { |v| opts[:repo] = v }
  o.on("--since DATE")  { |v| opts[:since] = v }
  o.on("--until DATE")  { |v| opts[:until] = v }
  o.on("--last DURATION", "relative window: Nd / Nw / Nm (e.g. 2w)") { |v| opts[:last] = v }
  o.on("--email ADDR", "git author email (repeatable)") { |v| opts[:emails] << v }
  o.on("--json", "emit machine-readable JSON instead of a report") { opts[:json] = true }
end.parse!

abort("missing required --user") unless opts[:user]
abort("provide --last OR --since, not both") if opts[:last] && opts[:since]
abort("provide a window: --last DURATION or --since YYYY-MM-DD") unless opts[:last] || opts[:since]

# Resolve the window into absolute inclusive dates.
if opts[:last]
  m = opts[:last].match(/\A(\d+)([dwm])\z/) or abort("--last must look like 10d, 2w, or 1m")
  n = m[1].to_i
  today = Date.today # UTC on this host; anchors a relative window to "now"
  opts[:until] = today.iso8601
  opts[:since] = case m[2]
  when "d" then (today - n).iso8601
  when "w" then (today - (n * 7)).iso8601
  when "m" then (today << n).iso8601
  end
else
  opts[:until] ||= Date.today.iso8601
end
Date.iso8601(opts[:since]) rescue abort("--since must be YYYY-MM-DD")
Date.iso8601(opts[:until]) rescue abort("--until must be YYYY-MM-DD")
abort("--since (#{opts[:since]}) is after --until (#{opts[:until]})") if opts[:since] > opts[:until]

REPO  = opts[:repo]
USER  = opts[:user]
SINCE = opts[:since]
UNTIL = opts[:until]
RANGE = "#{SINCE}..#{UNTIL}"
# Inclusive timestamp bounds (UTC) for filtering review/comment/commit timestamps.
WIN_LO = "#{SINCE}T00:00:00Z"
WIN_HI = "#{UNTIL}T23:59:59Z"

def in_window?(iso) = iso && iso >= WIN_LO && iso <= WIN_HI

# --- shell helpers -----------------------------------------------------------

# Detect GitHub's primary/secondary rate-limit responses so callers can back off.
def rate_limited?(text) = text =~ /rate limit|API rate limit|secondary rate|abuse detection/i

def run(*cmd)
  out, err, status = Open3.capture3(*cmd)
  unless status.success?
    if rate_limited?(err)
      warn("rate limit: #{cmd.join(" ")}\n#{err}")
      exit(RATE_LIMIT_EXIT)
    end
    abort("command failed: #{cmd.join(" ")}\n#{err}")
  end
  out
end

def gh_json(*args)
  JSON.parse(run("gh", *args))
end

# `gh search prs` field set we rely on.
SEARCH_FIELDS = "number,title,author,state,createdAt,closedAt,url"

def search_prs(*qualifiers)
  gh_json("search", "prs", "--repo", REPO, "--limit", "200",
    "--json", SEARCH_FIELDS, *qualifiers)
end

# --- PRs: opened / merged / closed-without-merge -----------------------------

opened = search_prs("--author", USER, "--created", RANGE)
# Merged set: PRs authored by USER merged in the window (any creation date).
# NOTE: --merged is a boolean flag; the date-range qualifier is --merged-at.
merged = search_prs("--author", USER, "--merged-at", RANGE)
merged_numbers = merged.map { |p| p["number"] }.to_set
# Closed-in-window minus merged-in-window == closed without merging.
closed_all = search_prs("--author", USER, "--closed", RANGE)
closed_unmerged = closed_all.reject { |p| merged_numbers.include?(p["number"]) }

# Enrich merged PRs with precise mergedAt (search results lack mergedAt).
merged.each do |p|
  detail = gh_json("pr", "view", p["number"].to_s, "--repo", REPO, "--json", "mergedAt")
  p.merge!(detail)
end

# --- Reviews & comments: exact timestamps within the window ------------------

# Prefilter candidate PRs the user touched, then pull exact event timestamps.
review_candidates  = search_prs("--reviewed-by", USER, "--updated", RANGE)
comment_candidates = search_prs("--commenter",   USER, "--updated", RANGE)
candidate_numbers  = (review_candidates + comment_candidates).map { |p| p["number"] }.uniq.sort

reviews  = []
comments = []
candidate_numbers.each do |n|
  pr_reviews = gh_json("api", "repos/#{REPO}/pulls/#{n}/reviews", "--paginate")
  pr_reviews.each do |r|
    next unless r.dig("user", "login") == USER
    next unless in_window?(r["submitted_at"])
    reviews << {pr: n, state: r["state"], at: r["submitted_at"], url: r["html_url"]}
  end

  pr_comments = gh_json("api", "repos/#{REPO}/issues/#{n}/comments", "--paginate")
  pr_comments.each do |c|
    next unless c.dig("user", "login") == USER
    next unless in_window?(c["created_at"])
    comments << {pr: n, at: c["created_at"], url: c["html_url"]}
  end
end
reviews.sort_by!  { |r| [r[:at], r[:pr]] }
comments.sort_by! { |c| [c[:at], c[:pr]] }
# One line per PR per distinct review verdict: collapses repeat COMMENTED/APPROVED
# reviews to a single entry, but keeps both rows when the user requested changes
# and later approved (distinct states). Earliest occurrence of each state wins.
reviews.uniq! { |r| [r[:pr], r[:state]] }
# One line per PR for comments, regardless of how many were left.
comments.uniq! { |c| c[:pr] }

# PR metadata (opener + title + canonical URL) gathered from every search result.
pr_meta = {}
(opened + merged + closed_all + review_candidates + comment_candidates).each do |p|
  pr_meta[p["number"]] ||= {opener: p.dig("author", "login"), title: p["title"], url: p["url"]}
end
[reviews, comments].each do |list|
  list.each do |e|
    m = pr_meta[e[:pr]] || {}
    e[:url] = m[:url] # link to the PR itself, not the individual event
    e[:opener] = m[:opener]
    e[:title] = m[:title]
  end
end
# Reviews/comments are about activity on OTHERS' work — drop self-authored PRs
# (commenting on your own PR isn't review activity).
reviews.reject!  { |r| r[:opener] == USER }
comments.reject! { |c| c[:opener] == USER }

# --- Commits across all branches (catches un-PR'd / draft work) --------------

commits = []
unless opts[:emails].empty?
  author_args = opts[:emails].flat_map { |e| ["--author", e] }
  raw = run("git", "log", "--all", "--no-merges",
    "--since=#{WIN_LO}", "--until=#{WIN_HI}",
    "--pretty=format:%H%x09%cI%x09%s", *author_args)
  # Resolve the default branch ref once (symbolic origin/HEAD -> origin/main fallback).
  sym, _e, st = Open3.capture3("git", "symbolic-ref", "--quiet", "refs/remotes/origin/HEAD")
  default_ref = st.success? && !sym.strip.empty? ? sym.strip : "origin/main"
  on_default = ->(sha) {
    _o, _e2, s = Open3.capture3("git", "merge-base", "--is-ancestor", sha, default_ref)
    s.success?
  }
  raw.each_line do |line|
    sha, date, subject = line.chomp.split("\t", 3)
    next unless sha
    merged_to_default = on_default.call(sha)
    # Only list containing branches for commits NOT on the default branch — that's
    # the signal for un-PR'd / unmerged work. Merged commits descend onto every
    # branch cut from main afterward, so listing them is pure noise.
    branches =
      if merged_to_default
        []
      else
        run("git", "branch", "-r", "--contains", sha, "--format=%(refname:short)")
          .split("\n").map(&:strip).reject { |b| b.include?("->") || b == "origin/main" }.sort
      end
    commits << {sha: sha, at: date, subject: subject, on_main: merged_to_default, branches: branches}
  end
  commits.uniq! { |c| c[:sha] }
  commits.sort_by! { |c| [c[:at], c[:sha]] }
end

# --- Output ------------------------------------------------------------------

def sort_prs(prs) = prs.sort_by { |p| p["number"] }

result = {
  repo: REPO, user: USER, since: SINCE, until: UNTIL,
  opened: sort_prs(opened),
  merged: sort_prs(merged),
  closed_unmerged: sort_prs(closed_unmerged),
  reviews: reviews,
  comments: comments,
  commits: commits,
  commit_scan: opts[:emails].empty? ? "skipped (no --email)" : "scanned #{opts[:emails].join(", ")}"
}

if opts[:json]
  puts JSON.pretty_generate(result)
  exit
end

def hdr(s) = puts("\n#{s}\n#{"=" * s.length}")

puts "Activity for @#{USER} in #{REPO} — #{SINCE} .. #{UNTIL} (inclusive, UTC)"

hdr("PRs opened (#{opened.size})")
sort_prs(opened).each { |p| puts "  #{p["createdAt"][0, 10]}  #{p["url"]}  #{p["title"]}" }

hdr("PRs merged (#{merged.size})")
sort_prs(merged).each { |p| puts "  #{(p["mergedAt"] || "")[0, 10]}  #{p["url"]}  #{p["title"]}" }

hdr("PRs closed without merging (#{closed_unmerged.size})")
sort_prs(closed_unmerged).each { |p| puts "  #{(p["closedAt"] || "")[0, 10]}  #{p["url"]}  #{p["title"]}" }

hdr("Reviews submitted (#{reviews.size})")
reviews.each { |r| puts "  #{r[:at][0, 10]}  #{r[:state].ljust(17)}  #{r[:url]}  by @#{r[:opener]} — #{r[:title]}" }

hdr("Comments (#{comments.size})")
comments.each { |c| puts "  #{c[:at][0, 10]}  #{c[:url]}  by @#{c[:opener]} — #{c[:title]}" }

hdr("Commits across all branches (#{commits.size}) — #{result[:commit_scan]}")
commits.each do |c|
  tag = c[:on_main] ? "[on main]" : "[UNMERGED]"
  puts "  #{c[:sha][0,9]}  #{c[:at][0,10]}  #{tag}  #{c[:subject]}"
  puts "             branches: #{c[:branches].join(", ")}" unless c[:branches].empty?
end
