
---
name: all-hands-weekly-summary
description: Summarize notable commits from the team over the previous week for all-hands presentation
allowed-tools: Bash, Read, Write, Grep, Glob
model: claude-sonnet-4-6
effort: medium
---

Generate a weekly summary of notable work committed by the team in the past week

## Team Members

Filter git log to only these authors:
- Autumn Forsythe
- Caitlin Cabrera
- Chris Born
- Cody Ortiz
- Matt Thompson
- Micah-Kolide
- iamharlie

## Steps

1. Run `cd ~/code/rails/k2 && git log` for the past 7 days filtered to the team authors above. Use `--since='7 days ago'` and repeat `--author=` for each team member. Include commit messages and bodies (`--format='%h %aN: %s%n%b'`).

2. ONLY report on things that merged to `main` (skip unmerged branches) 

3. Analyze the commits and filter for **notable, potentially marketable work**:
   - New features or meaningful progress on features
   - Important bug fixes (user-facing or high-impact)
   - Significant infrastructure or reliability improvements
   - **Skip**: trivial changes, dependency bumps, linting/formatting, minor refactors, test-only changes, CI config tweaks

4. Where multiple commits relate to the same feature or effort, group them into a single bullet.

5. Write the output to `weekly-summary.md` in the project root with this format:

```markdown
# Weekly Summary - {date range}

- **{Short title of what shipped}** — {One sentence on why this matters or what it enables.}
- **{Short title}** — {One sentence context.}
...
```

6. Tell the user the file has been written and print the contents.
