ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
# this sets up the 24bit colors properly, or something.
# not sure really, but it makes emacs colors in tmux
# behave properly
tic -x -o ~/.terminfo "$HOME/.dotfiles/tmux/xterm-24bit.terminfo"

if [ ! -d "$HOME/.dotfiles/tmux/tmux-plugins/tmux-which-key" ]; then
    git clone --recursive https://github.com/alexwforsythe/tmux-which-key "$HOME/.dotfiles/tmux/tmux-plugins/tmux-which-key"
fi
