#!/bin/bash

ln -s ~/.dotfiles/git/gitignore.symlink ~/.gitignore
ln -s ~/.dotfiles/git/gitconfig.symlink ~/.gitconfig
ln -s ~/.dotfiles/git/gitmessage.symlink ~/.gitmessage
ln -s ~/.dotfiles/git/gitattributes.symlink ~/.gitattributes
ln -s ~/.dotfiles/git/git-templates/ ~/.git-templates

# for ssh signing of commits
touch ~/.ssh/allowed_signers
