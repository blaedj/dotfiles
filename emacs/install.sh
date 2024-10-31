#!/bin/bash

if [ "$(uname -s)" = "Linux" ]
then 
 echo "edit: NOT Installing emacs26... you'll need to install it yourself"

 # sudo add-apt-repository ppa:kelleyk/emacs
 # sudo apt install emacs26
fi

if test ! $(which emacs)
then
    echo "installing Emacs from: https://github.com/d12frosted/homebrew-emacs-plus"
    echo "If this fails, try brew tap d12frosted/emacs-plus"
    brew install emacs-plus@29 --with-native-comp --with-xwidgets --with-dragon-icon
    ln -s /opt/homebrew/opt/emacs-plus@28/Emacs.app /Applications
    # make sure emacsclient is in the path
    sudo ln -s /opt/homebrew/bin/emacsclient /usr/local/bin/
fi

if [ ! -d "~/code/elisp/spacemacs" ]; then
    git clone https://github.com/syl20bnr/spacemacs ~/code/elisp/spacemacs
fi

if [ ! -d "~/code/elisp/doom-emacs/" ]; then
    echo "cloning doomeamacs..."
    git clone --depth 10 https://github.com/doomemacs/doomemacs ~/code/elisp/doom-emacs
fi

if [ ! -d "~/.doom.d" ]; then
    ln -s "~/.dotfiles/doom.d" "~/.doom.d/"
    echo "you probably want to run the following commands: "
    echo "  ~/code/elisp/doom-emacs/bin/doom sync"
    echo "  ~/code/elisp/doom-emacs/bin/doom env "
    echo "  emacs --batch -f nerd-icons-install-fonts"
fi

if [ ! -f "~/.emacs.d/chemacs.el" ]; then
    echo "please install chemacs: https://github.com/plexus/chemacs2"
    echo "once any current .emacs.d/ is backed up somewhere, run: "
    echo "  git clone https://github.com/plexus/chemacs2.git ~/.emacs.d"
else
    if [ ! -f "~/.emacs-profiles.el" ]; then
        ln -s ~/.dotfiles/emacs/.emacs-profiles.el ~/.emacs-profiles.el
    fi
fi

# run on the develop branch of spacemacs, as master has a lot of missing bugfixes etc
# (cd ~/code/elisp/spacemacs && git checkout develop)

# if [ ! -d "~/.emacs.d/" ]; then
#     ln -s ~/code/elisp/spacemacs ~/.emacs.d
# fi
# ln -s ~/.dotfiles/emacs/.spacemacs ~/.spacemacs
# ln -s ~/.dotfiles/emacs/ ~/.emacs.d/private
