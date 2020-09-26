#!/usr/bin/env bash

for TOOL in fzf curl htop silversearcher-ag tmux jq firefox libpq-dev; do
    sudo apt install $TOOL
    echo "Installed $TOOL"
done

# link the fzf config, as .zshrc expects it here
ln -s ~/.dotfiles/linux/fzf.zsh ~/.fzf.zsh
