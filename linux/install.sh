#!/usr/bin/env bash

for TOOL in fzf curl htop silversearcher-ag tmux jq firefox libpq-dev; do
    sudo apt install $TOOL
    echo "Installed $TOOL"
done
