---
name: team-github-activity
description: Use when comparing several GitHub users' activity (PRs opened/merged/closed, reviews, comments, optionally commits) over a date window — e.g. "how are my direct reports doing", weekly/team activity summaries, manager 1:1 prep, or activity for a roster of logins in a repo. Runs serially to avoid GitHub search-API rate limits.
version: 1.0.0
---

# Team GitHub Activity

Compare a roster of GitHub users' activity in a repo over one fixed window, then
write comparative insights. Two bundled scripts in `scripts/`:

- `gh_team_activity.rb` — **orchestrator.** Resolves the window once, runs each
  member serially, paces against the search-API quota, retries on 403, and prints
  a comparison table + per-person detail (or `--json`). **Use this for 2+ people.**
- `gh_user_activity.rb` — single-user worker. Use directly only for one person or
  when you need commit scanning (`--email`, see below).

## The rate-limit rule (why serial, not parallel)

GitHub's **search API is capped at ~30 requests/min.** Each per-user run makes ~5
search calls. Fanning out across a team in parallel (background jobs, one Bash call
each) **reliably trips HTTP 403 "API rate limit exceeded"** — this happened and is
why the orchestrator exists.

- **DO** run `gh_team_activity.rb` (serial + self-pacing). It checks live quota
  before each member and sleeps one ~60s cycle if the budget is low; on a 403 it
  backs off and retries (up to 6×).
- **DO NOT** launch the per-user script for multiple people in parallel, and don't
  wrap the orchestrator in background fan-out. Serial is the design, not a fallback.
- If you must run the single-user script by hand for several people, run them **one
  at a time** and wait for each to finish.

## Usage

```bash
SKILL=~/.dotfiles/agents/claude/skills/team-github-activity

# Roster file + relative window (anchored to today; resolved dates print in header):
$SKILL/scripts/gh_team_activity.rb --last 1w --roster $SKILL/rosters/direct-reports.txt

# Absolute window (fully reproducible) + inline members:
$SKILL/scripts/gh_team_activity.rb --since 2026-06-22 --until 2026-06-29 \
  --member adccb="Autumn Forsythe" --member pelted="Chris Born"

# Combined JSON for your own analysis:
$SKILL/scripts/gh_team_activity.rb --last 2w --roster $SKILL/rosters/direct-reports.txt --json
```

- Window: `--last Nd|Nw|Nm` OR `--since YYYY-MM-DD` (with optional `--until`, defaults to today). Both bounds inclusive, UTC.
- Repo: `--repo ORG/REPO` (default `kolide/k2`). Parameterized so the skill works across projects.
- Roster: `--roster FILE` (lines of `login<whitespace>Display Name`; `#` comments ok) and/or repeatable `--member LOGIN[="Name"]`. `--member` wins on duplicate login.

## What the numbers mean

| Column | Meaning |
|--------|---------|
| opened | PRs the user created in the window (any later state) |
| merged | PRs authored by the user that merged in the window |
| closed-no-merge | PRs the user closed without merging |
| reviews | review verdicts submitted on **others'** PRs (self-PRs excluded; collapsed to one row per PR per distinct verdict) |
| comments | PRs on which the user commented (others' PRs only; one row per PR) |

- `opened` and `merged` **overlap** — a PR opened and merged in-window counts in both. They measure window activity, not distinct PRs.
- Determinism: same repo state + window + roster ⇒ identical output. A relative `--last` is resolved to absolute dates once, so every member shares the same anchor.

## Commit scanning (un-PR'd / draft work)

The orchestrator does **not** scan commits (it needs git author emails per person,
which logins don't give you). For one person's draft/un-merged work, run the
single-user script directly with a fetched local checkout:

```bash
git fetch --all
$SKILL/scripts/gh_user_activity.rb --user pelted --last 2w --email chris@kolide.co --email chris@example.com
```

## Writing the insights

After running, don't just dump the table — give comparative read:
- Who leads on volume (merges) vs. collaboration (reviews); call out anyone with **0 reviews** (siloed) or lots of reviews but few merges (review-heavy).
- Theme each person's merges (what area: auth, API, checks, frontend…).
- Distinguish "quiet because lightweight week" from "quiet because mid-flight on an open/long-lived PR" using the OPENED-still-open list.
- **Always state caveats:** one week is noisy (prefer `--last 2w`/`1m` for trend); commit scan skipped means draft work is invisible; review count measures collaboration not raw output.

## Common mistakes

- **Parallelizing the runs** → 403 rate limit. Use the orchestrator; it's serial by design.
- Passing `--last` to multiple separate single-user runs spanning midnight UTC → different anchors per person. Use the orchestrator (resolves the window once) or pass absolute `--since/--until`.
- Reading `merged + opened` as distinct PRs. They overlap.
- Treating low review counts as low engagement without checking whether the person's area just has few cross-cutting PRs.
