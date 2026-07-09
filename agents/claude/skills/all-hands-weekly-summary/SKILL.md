
---
name: all-hands-weekly-summary
description: Summarize notable commits from the team over the previous week for all-hands presentation
allowed-tools: Bash, Read, Write, Grep, Glob
model: claude-sonnet-4-6
effort: medium
---

Generate a weekly summary of notable work committed by the team in the past week

## Team Members

Filter git log to only these authors (GitHub usernames in parentheses):
- Autumn Forsythe (adccb)
- Caitlin Cabrera (cacab)
- Chris Born (pelted)
- Cody Ortiz (codyortiz)
- Matt Thompson (mjthompsgb-1P)
- Micah-Kolide (Micah-Kolide)
- iamharlie (iamharlie)

## Steps

1. Run `cd ~/code/rails/k2 && git log` for the past 7 days filtered to the team authors above. Use `--since='7 days ago'` and repeat `--author=` for each team member. Include commit messages and bodies (`--format='%h %aN: %s%n%b'`).

2. ONLY report on things that merged to `main` (skip unmerged branches) 

3. Analyze the commits and split them into two buckets:
   - **Notable, potentially marketable work**: new features or meaningful progress on features, important bug fixes (user-facing or high-impact), significant infrastructure or reliability improvements.
   - **Trivial**: dependency bumps, linting/formatting, minor refactors, test-only changes, CI config tweaks, flag/dead-code cleanup, docs/changelog-only commits, and other small internal fixes that don't rise to "notable."

4. Where multiple commits relate to the same feature or effort, group them into a single bullet.

5. Write the output to `weekly-summary.md` in the project root with this format:

```markdown
# Weekly Summary - {date range}

- **{Short title of what shipped}** — {One sentence on why this matters or what it enables.} ({Author})
- **{Short title}** — {One sentence context.} ({Author})
...

## Trivial / Other Changes

- {One-line blurb of what changed} ({Author}) — [{short SHA}](https://github.com/kolide/k2/commit/{full SHA})
- {One-line blurb} ({Author}) — [{short SHA}](https://github.com/kolide/k2/commit/{full SHA})
...
```

   The repo's GitHub remote is `kolide/k2` — build commit links from that. Include every commit deemed trivial, not just a sample.

6. Tell the user the file has been written and print the contents.
