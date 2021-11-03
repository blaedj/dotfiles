#!/bin/sh

# Need to change this to rbenv
if test ! $(which rbenv)
then
  echo "  Installing rbenv for you."

  if [ "$(uname -s)" = "Linux" ]
  then
     curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash

     # dependencies needed by ruby-build
     sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev
  fi

  if [ "$(uname -s)" = "Darwin" ]
  then
     brew install rbenv > /tmp/rbenv-install.log
  fi
fi

# if test ! $(which ruby-build)
# then
#   echo "  Installing ruby-build for you."
#   brew install ruby-build > /tmp/ruby-build-install.log
# fi
ln -s ~/.dotfiles/ruby/rspec.symlink ~/.rspec
ln -s ~/.dotfiles/ruby/pryrc.symlink ~/.pryrc
ln -s ~/.dotfiles/ruby/rubocop.yml.symlink ~/.rubocop.yml
ln -s ~/.dotfiles/ruby/reek.yml.symlink ~/.reek.yml
