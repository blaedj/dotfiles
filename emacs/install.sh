#!/bin/bash
if [ ! -d "~/code/elisp/spacemacs" ]; then
    git clone https://github.com/syl20bnr/spacemacs ~/code/elisp/spacemacs
fi

# run on the develop branch of spacemacs, as master has a lot of missing bugfixes etc
(cd ~/code/elisp/spacemacs && git checkout develop )

if [ ! -d "~/.emacs.d/" ]; then
    ln -s ~/code/elisp/spacemacs ~/.emacs.d
fi
ln -s ~/.dotfiles/emacs/.spacemacs ~/.spacemacs
ln -s ~/.dotfiles/emacs/ ~/.emacs.d/private
