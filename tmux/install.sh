ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
# this sets up the 24bit colors properly, or something.
# not sure really, but it makes emacs colors in tmux
# behave properly
tic -x -o ~/.terminfo ./xterm-24bit.terminfo
