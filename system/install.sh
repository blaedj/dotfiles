# NOTE: None of this seems to be needed - the file paths described don't exist,
# and fzf still works fine
#
# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
    export PATH="$PATH:/usr/local/opt/fzf/bin"
fi


ln -s ~/.dotfiles/system/.bashrc ~/.bashrc

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# NOTE: this appears to invalid, because this file doesn't exist.
# ------------
# source "/usr/local/opt/fzf/shell/key-bindings.zsh"
source "$(brew --prefix fzf)/shell/key-bindings.zsh"
