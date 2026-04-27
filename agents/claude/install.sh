#!/bin/bash

mkdir -p ~/.claude

ln -sf ~/.dotfiles/agents/claude/settings.json ~/.claude/settings.json
ln -sf ~/.dotfiles/agents/claude/statusline.sh ~/.claude/statusline.sh
ln -sfn ~/.dotfiles/agents/claude/skills ~/.claude/skills
