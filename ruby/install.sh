#!/bin/sh

## Need to change this to rvm
# if test ! $(which rbenv)
# then
#   echo "  Installing rbenv for you."
#   brew install rbenv > /tmp/rbenv-install.log
# fi

# if test ! $(which ruby-build)
# then
#   echo "  Installing ruby-build for you."
#   brew install ruby-build > /tmp/ruby-build-install.log
# fi
ln -s ~/.dotfiles/ruby/rspec.symlink ~/.rspec
ln -s ~/.dotfiles/ruby/rubocop.yml.symlink ~/.rubocop.yml
