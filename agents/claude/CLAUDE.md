# Global preferences

These apply across all repositories and machines (loaded into every session via
`~/.claude/CLAUDE.md`, symlinked from this dotfiles file).

## Skills

- Reusable, cross-project skills live in `~/.dotfiles/agents/claude/skills/`
  (the source of truth; `~/.claude/skills/` is a symlink to it). They are
  version-controlled and meant to be extended over time.
- Project-specific skills go in that repo's own `.claude/skills/`.
- When authoring a skill that is reusable or that I say I'll extend later, create
  it under `~/.dotfiles/agents/claude/skills/<name>/` and keep repo/project values
  parameterized so it generalizes.
