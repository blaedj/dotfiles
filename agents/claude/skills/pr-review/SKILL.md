---
name: pr-review
description: Review code changes for correctness, regressions, security, performance, test coverage, and fit with project conventions. Use when reviewing a GitHub PR, branch, diff, staged changes, or other change set.
argument-hint: [pr_number_or_url | branch | commit_range | staged]
---

# Code Review

Perform a thorough, critical, and opinionated review of a change set. Prioritize bugs, regressions, security issues, performance problems, code quality issues, missing tests, and violations of this codebase's conventions.

## Workflow

1. Read the repo root `CLAUDE.md` or `AGENTS.md` first.
2. Determine the review input from `$ARGUMENTS`:
   - PR number or URL: fetch metadata and diff with `gh` or GitHub MCP.
   - Branch: diff against the appropriate base branch.
   - Commit range: review that diff.
   - `staged`: review `git diff --staged`.
   - No clear input: ask the user what to review.
3. Understand the blast radius: what problem is being solved, and what systems or features the change touches.
4. If a PR is provided, read the title, description, commits, and relevant comments.
5. If the goal is unclear, ask the user for context before giving a verdict.
6. Read the full diff and enough surrounding code to understand how each change fits the codebase.
7. Check related tests and docs when behavior changes.

Do not review the diff in isolation. Ground the review in the local codebase and this repository's patterns.

## What to Evaluate

- **Correctness**: the change should solve the stated problem, handle edge cases, and be free of bugs and regressions.
- **Code quality, readability, and maintainability**: the change should be clean, high quality, easy to follow, readable, and sustainable to maintain and modify.
- **Conventions**: the change should follow this repo's patterns and conventions across every relevant layer, technology, and file type. It should avoid introducing or perpetuating anti-patterns.
- **Performance**: the change should be performant and efficient, but not at the expense of the defined code quality goals. It should avoid N+1 queries, excess API calls, unnecessary re-renders, avoidable complexity, and any other performance issues.
- **Security**: the change should be secure and follow security best practices. The change should validate and sanitize inputs, enforce authentication and authorization correctly, protect sensitive user and application data, and avoid common web security risks.
- **Testing**: the change should include coverage for changed behavior, failure modes, and important edge cases, and the tests should assert meaningful behavior instead of only exercising code.
- **Design, architecture, and scope**: the change should be well-designed, well-considered, make worthwhile tradeoffs, fit the rest of the codebase cleanly, and remain reasonably scoped.
- **Dependencies**: any added library should be necessary and used appropriately.

## Findings

- Critical: broken behavior, likely regressions, data loss, security issues, missing authorization, or defects that should block merge
- Suggestion: meaningful improvements to correctness, resilience, performance, maintainability, or test coverage
- Nit: minor style or readability feedback that is clearly optional
- Question: uncertainty about intent, tradeoffs, or missing context that affects confidence in approval

- Focus on issues that matter. Do not pad the review with trivial comments.
- Flag change hygiene issues when unrelated changes are mixed in or the work should be split into smaller reviewable pieces.
- Cite the file and line number when available, and ensure the file and line numbers are cited accurately from the reviewed change set, unless referencing a different change or branch, which should be noted.
- Explain what is wrong, why it matters, and suggest a concrete fix when possible.
- If unsure, say so and phrase it as a question.
- Call out genuinely good choices when they are specific and notable.

## Output

Present findings first, ordered by severity. Keep the summary brief.

Use this structure:

```markdown
## Code Review: [brief title]

### Critical Issues

**[Short title]** — `path/to/file.rb:42`
[What is wrong, why it matters, and a suggested fix.]

### Suggestions

**[Short title]** — `path/to/file.rb:42`
[Improvement and rationale.]

### Nits

- `path/to/file.rb:42` — [minor optional feedback]

### Questions

- [Question about intent, tradeoff, or missing context]

### What's Good

- [Specific good choice and why it helps]

### Summary

[1-3 sentences on what changed and overall assessment.]

### Verdict: [APPROVE | REQUEST CHANGES | DISCUSS]
```

Omit empty sections. If there are no findings, say so explicitly and mention any remaining risk or testing gaps that limit confidence.
