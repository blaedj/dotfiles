---
name: git-commit
description: Write a git commit message following project conventions. Use when the user asks to commit, draft a commit message, or wants help writing a commit.
---

Write a git commit message for the current staged changes (or, if nothing is staged, the working tree diff).

## Steps

1. Run `git diff --staged` (fall back to `git diff HEAD` if empty) to see what's changing.
2. Run `git log --oneline -10` to see recent commit style for tone/tense calibration.
3. Draft a commit message using the template below.
4. Run the commit using that message via a HEREDOC (see below). Do NOT include a "Co-Authored-By" trailer.

## Commit message template

```
<imperative mood summary, 60 chars max>

This commit:
- <what it does — technical, one bullet per distinct change>
- <second bullet if needed>

Why?
- <why this change was necessary>
- <how it addresses the problem, and any side effects or gotchas>
```

Rules:
- Summary line: imperative mood ("Add X", "Fix Y", "Remove Z"), no period, ≤60 chars.
- "This commit:" section: 1–3 bullets, each a concise technical description of what changed.
- "Why?" section: explain motivation, not mechanics. Note side effects or non-obvious consequences.
- Wrap body lines at 72 characters.
- If there are issue/PR references, append them at the bottom: `Resolves: #123` or `See also: #456`.
- Do NOT add a "Co-Authored-By: Claude" trailer.

## Running the commit

Pass the message via HEREDOC to avoid quoting issues:

```bash
git commit -m "$(cat <<'EOF'
Summarize changes in around 50 characters or less

This commit:
- First bullet

Why?
- Reason
EOF
)"
```
