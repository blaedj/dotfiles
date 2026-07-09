---
name: one-on-one-prep
description: Use when preparing for a recurring 1:1 with a direct report — "prep for my 1:1 with Chris", "1:1 prep for cody", "what should I cover with matt". Pulls the report's recent GitHub activity, recaps the last 1:1, surfaces open follow-ups, and suggests talking points that connect the two. Reads org-mode 1:1 notes + Zoom AI summaries.
allowed-tools: Bash, Read, Edit, Write
---

# One-on-one prep

Walk into a 1:1 prepared: recent GitHub activity **plus** continuity from the last
meeting, with the two connected. Notes give continuity, GitHub gives ground truth;
this skill's job is to connect them.

Invoked by first name / directory key: `prep for my 1:1 with chris`.

## Paths (machine-specific — edit here if they move)

- `DRS_ROOT` = `~/Dropbox/org/work_notes/kolide/drs`
- `ACTIVITY_SCRIPT` = `~/.dotfiles/agents/claude/skills/team-github-activity/scripts/gh_user_activity.rb`
- `ROSTER` = `~/.dotfiles/agents/claude/skills/team-github-activity/rosters/direct-reports.txt`

The GitHub script and roster are **owned by the `team-github-activity` skill** — this
skill reuses them by reference. Do not copy or edit them here.

## Step 1 — Resolve the person

You're given a first name / dir key (e.g. `chris`). Resolve it to three things:

1. **Directory** — `DRS_ROOT/<name>`. Confirm it exists. If not, list the
   directories under `DRS_ROOT` and ask which report is meant. Stop.
2. **GitHub login** — read `ROSTER` (lines are `login<whitespace>Display Name`).
   The dir name is the lowercase first token of the display name
   (`Chris Born` → `chris`). Find the roster line whose display name's first word,
   downcased, equals `<name>`; its first token is the login (`pelted`).
   - If no roster line matches, tell the user the report isn't in the roster and
     ask for the GitHub login (or proceed notes-only if they say so).

Do **not** modify the roster — `team-github-activity` parses it as
`login, name = split(/\s+/, 2)`, so a third column would corrupt display names.

## Step 2 — Read the notes (org file)

Read `DRS_ROOT/<name>/1_1_meeting_notes.org`.

- The file is org-mode: a top `* <year>` heading, then one `** YYYY-MM-DD` heading
  per meeting, **newest first** (but don't rely on order — pick the max date).
- **Last 1:1 date** = the maximum `** YYYY-MM-DD` heading. Remember it for Step 4.
- **Open follow-ups** — read the raw text of the **last 3 dated entries** and
  identify every *unresolved* action item. The format is inconsistent, so read for
  meaning, don't pattern-match rigidly. Unresolved items look like:
  - `**** TODO ...` headings (a matching `DONE` means resolved — skip those)
  - unchecked `- [ ]` checkboxes (`- [x]` is done — skip)
  - narrative commitments ("Chris is going to…", "Blaed to follow up on…")

  Attribute an **owner** to each (you vs. the report) — from a trailing `(Blaed)` /
  `(Chris)`, or inferred from the sentence. When genuinely unclear, mark it `(?)`.
- **Last meeting topics** — the Topics/free text under the most recent entry, for
  the recap.

If the file doesn't exist or has no dated entries, treat this as a **new report**:
skip recap + follow-ups, note "no prior 1:1 found," and continue to GitHub activity.

## Step 3 — Read the latest AI summary

In `DRS_ROOT/<name>/ai_summaries/`, filenames embed a date but the layout varies
across reports (`chris-blaed-2026-06-25.md`, `2026-06-24_harlie-blaed-1-1.md`,
`2026-05-28_1-1_ai_summary.md`). Pick the file whose basename contains the **latest
`YYYY-MM-DD`**. Read it for the Quick recap / Next steps.

If the directory is missing or empty, skip this step (use the org entry alone —
don't fail).

## Step 4 — Pull GitHub activity

Run the activity script, windowed to the gap since the last 1:1:

```bash
~/.dotfiles/agents/claude/skills/team-github-activity/scripts/gh_user_activity.rb \
  --user <login> --since <last-1:1-date>
```

- `--since` is the last-1:1 date from Step 2 (inclusive), so activity lines up with
  the period you'll discuss.
- If there was **no prior 1:1** (new report), use `--last 2w` instead.
- Repo defaults to `kolide/k2` — pass `--repo` only if asked.

## Step 5 — Produce the prep (to chat)

Print, in this order:

1. **Open follow-ups / carryover** — the unresolved items from Step 2, grouped by
   owner (yours vs. theirs). This is the accountability list — lead with it.
2. **Last meeting recap** — 2–3 sentences distilling the last org entry's topics +
   the AI summary's Quick recap. Enough to remember the thread.
3. **GitHub activity** — the opened / merged / reviewed summary from Step 4.
4. **Suggested talking points** — *synthesis*: cross-reference the GitHub activity
   against the open follow-ups. Call out follow-ups the activity appears to resolve
   (e.g. "merged #14611 → closes the 06-25 'merge this + delegate' item — ask about
   the delegation write-up"), work that's in-flight, and anything opened-but-unmerged
   worth checking on. This connection is the point of the skill; don't just list.

Keep it tight and scannable — this is read in the two minutes before the call.

## Step 6 — Offer to seed the next org entry (opt-in)

After printing, **offer** (never write silently): prepend a new
`** <today's date>` entry to `1_1_meeting_notes.org`, above the latest one, with:

- `*** Follow-ups` — the still-open carried-forward items (as `**** TODO ...`)
- `*** Topics` — the suggested talking points as bullets

If the user accepts, prepend it directly under the `* <year>` heading (matching the
newest-first ordering) using Edit. Preserve existing formatting and blank lines.

## Scope

Read **only** `1_1_meeting_notes.org` and the latest `ai_summaries/*.md`. Ignore
midyear-checkin, calibration cards, peer reviews, and todo/scratch files — those are
review-season artifacts, not 1:1 continuity, and pull the conversation off-track.
