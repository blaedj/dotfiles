#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)" > /tmp/homebrew-install.log
fi

# Install homebrew packages
brew install grc coreutils spark eza php ripgrep shellcheck fd terminal-notifier

# install some casks
brew install alfred rectangle tripmode jordanbaird-ice ngrok iterm2 firefox hazel brave-browser --cask

exit 0
