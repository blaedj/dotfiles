#!/usr/bin/env bash

set -e

for TOOL in fzf curl htop silversearcher-ag tmux jq firefox libpq-dev; do
    sudo apt install $TOOL
    echo "Installed $TOOL"
done

# delta is a git diff-er
wget https://github.com/dandavison/delta/releases/download/0.16.5/git-delta_0.16.5_amd64.deb

sudo dpkg -i git-delta_0.16.5_amd64.deb
rm git-delta_0.16.5_amd64.deb



# link the fzf config, as .zshrc expects it here
ln -s ~/.dotfiles/linux/fzf.zsh ~/.fzf.zsh
