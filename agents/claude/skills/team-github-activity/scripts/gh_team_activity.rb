#!/usr/bin/env ruby
# frozen_string_literal: true

# Compare a roster of GitHub users' activity in a repo over one fixed window.
#
# WHY THIS EXISTS: the per-user script (gh_user_activity.rb) makes ~5 GitHub
# *search* API calls per user, and the search API is capped at ~30 requests/min.
# Running the per-user script in parallel across a team blows that limit instantly
# (HTTP 403 "API rate limit exceeded"). This orchestrator runs members SERIALLY,
# paces itself against the live search-quota, and retries with backoff on 403 —
# so a whole team report completes in one shot without manual babysitting.
#
# Determinism: the window is resolved to absolute dates ONCE here and passed to
# every per-user run, so a relative --last anchors all members to the same day.
# Output rows are sorted by a stable key. Same repo state + same window + same
# roster => identical output.
#
# Requirements: `gh` (authenticated), Ruby 3.x. Sits next to gh_user_activity.rb.
#
# Usage:
#   gh_team_activity.rb --since 2026-06-22 --until 2026-06-29 \
#     --member adccb="Autumn Forsythe" --member pelted="Chris Born" [...]
#
#   gh_team_activity.rb --last 1w --repo kolide/k2 --roster reports.txt
#
#   gh_team_activity.rb --last 2w --roster reports.txt --json > team.json
#
# Roster sources (combine freely; --member wins on duplicate login):
#   --member LOGIN              bare login, display name = login
#   --member LOGIN="Full Name"  login with a display name
#   --roster FILE               one member per line: `login<TAB or whitespace>Display Name`
#                               (blank lines and lines starting with # are ignored)
#
# Window: identical rules to gh_user_activity.rb (--last Nd/Nw/Nm OR --since [+ --until]).

require "json"
require "date"
require "optparse"
require "open3"

SCRIPT_DIR     = __dir__
PER_USER       = File.join(SCRIPT_DIR, "gh_user_activity.rb")
RATE_LIMIT_EXIT = 2
SEARCHES_PER_USER = 5      # opened, merged, closed, reviewed-by, commenter
QUOTA_FLOOR    = 8         # pause before a run if fewer search calls than this remain
MAX_RETRIES    = 6         # per member, on rate-limit backoff

opts = {repo: "kolide/k2", members: {}, json: false}
OptionParser.new do |o|
  o.banner = "Usage: gh_team_activity.rb (--last DUR | --since DATE [--until DATE]) [--repo R] (--member L[=Name] | --roster FILE) [--json]"
  o.on("--repo ORG/REPO") { |v| opts[:repo] = v }
  o.on("--since DATE")    { |v| opts[:since] = v }
  o.on("--until DATE")    { |v| opts[:until] = v }
  o.on("--last DURATION") { |v| opts[:last] = v }
  o.on("--member SPEC", "LOGIN or LOGIN=\"Display Name\" (repeatable)") do |v|
    login, name = v.split("=", 2)
    opts[:members][login.strip] = (name && !name.strip.empty?) ? name.strip : login.strip
  end
  o.on("--roster FILE", "file of `login<whitespace>Display Name` lines") do |f|
    opts[:roster] = f
  end
  o.on("--json", "emit combined machine-readable JSON") { opts[:json] = true }
end.parse!

# Merge roster file (members passed via --member take precedence on conflict).
if opts[:roster]
  abort("roster file not found: #{opts[:roster]}") unless File.file?(opts[:roster])
  File.readlines(opts[:roster], chomp: true).each do |line|
    next if line.strip.empty? || line.strip.start_with?("#")
    login, name = line.strip.split(/\s+/, 2)
    opts[:members][login] ||= (name && !name.empty?) ? name : login
  end
end

abort("no members: pass --member and/or --roster") if opts[:members].empty?
abort("provide --last OR --since, not both") if opts[:last] && opts[:since]
abort("provide a window: --last DURATION or --since YYYY-MM-DD") unless opts[:last] || opts[:since]

# Resolve the window to absolute inclusive dates ONCE, so every member uses the
# identical anchor (critical for --last reproducibility across the roster).
if opts[:last]
  m = opts[:last].match(/\A(\d+)([dwm])\z/) or abort("--last must look like 10d, 2w, or 1m")
  n = m[1].to_i
  today = Date.today
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

REPO = opts[:repo]
SINCE = opts[:since]
UNTIL = opts[:until]

# --- search-quota pacing -----------------------------------------------------

# Live search-API budget: {remaining:, reset_epoch:}. Returns nil if unavailable
# (we then just proceed; the reactive retry below still protects us).
def search_quota
  out, _err, st = Open3.capture3("gh", "api", "rate_limit",
    "--jq", "{remaining: .resources.search.remaining, reset: .resources.search.reset}")
  return nil unless st.success?
  j = JSON.parse(out)
  {remaining: j["remaining"], reset: j["reset"]}
rescue
  nil
end

# Sleep until the search bucket resets (plus a small buffer). Bounded so a bad
# clock can't hang us. Prints to stderr so progress is visible.
def wait_for_reset(reset_epoch, why)
  secs = reset_epoch ? (reset_epoch - Time.now.to_i + 3) : 30
  secs = 3 if secs < 3
  secs = 75 if secs > 75   # search window is 60s; never wait more than one cycle + buffer
  warn("  [pace] #{why}; sleeping #{secs}s for search quota to reset…")
  sleep(secs)
end

# Before a member, ensure enough search budget remains; otherwise wait one cycle.
def pace_before_run!
  q = search_quota
  return unless q
  if q[:remaining] < QUOTA_FLOOR
    wait_for_reset(q[:reset], "search quota low (#{q[:remaining]} left, need ~#{SEARCHES_PER_USER})")
  end
end

# --- run one member, with rate-limit backoff ---------------------------------

def run_member(login)
  attempt = 0
  loop do
    attempt += 1
    pace_before_run!
    out, err, st = Open3.capture3(
      "ruby", PER_USER, "--user", login, "--repo", REPO,
      "--since", SINCE, "--until", UNTIL, "--json"
    )
    return JSON.parse(out) if st.success?

    if st.exitstatus == RATE_LIMIT_EXIT && attempt <= MAX_RETRIES
      wait_for_reset(search_quota&.fetch(:reset, nil), "rate limited on @#{login} (attempt #{attempt}/#{MAX_RETRIES})")
      next
    end
    warn("  [error] @#{login} failed (exit #{st.exitstatus}):\n#{err}")
    return {"error" => err.strip, "user" => login}
  end
end

# --- collect serially --------------------------------------------------------

warn("Collecting #{opts[:members].size} members in #{REPO}, #{SINCE}..#{UNTIL} (serial, rate-limit aware)…")
results = {}
opts[:members].each_key do |login|
  warn("→ @#{login}")
  results[login] = run_member(login)
end

combined = {
  repo: REPO, since: SINCE, until: UNTIL,
  members: opts[:members],
  results: results
}

if opts[:json]
  puts JSON.pretty_generate(combined)
  exit
end

# --- report ------------------------------------------------------------------

def n(data, key) = data[key].is_a?(Array) ? data[key].size : 0

puts "# Team GitHub activity — #{REPO}"
puts "Window: #{SINCE} .. #{UNTIL} (inclusive, UTC)"
puts

# Stable row order: most merges first, then login.
rows = opts[:members].map do |login, name|
  d = results[login] || {}
  {name: name, login: login, err: d["error"],
   opened: n(d, "opened"), merged: n(d, "merged"),
   closed: n(d, "closed_unmerged"), reviews: n(d, "reviews"), comments: n(d, "comments")}
end
rows.sort_by! { |r| [-r[:merged], r[:login]] }

puts "## Summary"
puts
puts "| Name | login | opened | merged | closed-no-merge | reviews | comments |"
puts "|------|-------|:--:|:--:|:--:|:--:|:--:|"
rows.each do |r|
  if r[:err]
    puts "| #{r[:name]} | #{r[:login]} | — | — | — | — | _error_ |"
  else
    puts "| #{r[:name]} | #{r[:login]} | #{r[:opened]} | #{r[:merged]} | #{r[:closed]} | #{r[:reviews]} | #{r[:comments]} |"
  end
end
puts
puts "_opened/merged overlap: a PR opened and merged in-window counts in both._"

puts "\n## Per-person detail\n"
rows.each do |r|
  d = results[r[:login]] || {}
  puts "\n### #{r[:name]} (@#{r[:login]})"
  if r[:err]
    puts "  ERROR: #{r[:err]}"
    next
  end
  unless d["merged"].to_a.empty?
    puts "MERGED:"
    d["merged"].each { |p| puts "  ##{p["number"]} #{p["title"]}" }
  end
  open_only = d["opened"].to_a.reject { |p| p["state"] == "merged" }
  unless open_only.empty?
    puts "OPENED (still open):"
    open_only.each { |p| puts "  ##{p["number"]} #{p["title"]}" }
  end
  unless d["closed_unmerged"].to_a.empty?
    puts "CLOSED WITHOUT MERGE:"
    d["closed_unmerged"].each { |p| puts "  ##{p["number"]} #{p["title"]}" }
  end
end
