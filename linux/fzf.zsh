# Setup fzf
#---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
    export PATH="$PATH:/usr/local/opt/fzf/bin"
fi

# Auto-completion
#----------------
[[ $- == *i* ]] && source "/usr/share/doc/fzf/examples/completion.zsh" 2> /dev/null

# Key Bindings
#--------------
source "/usr/share/doc/fzf/examples/key-bindings.zsh"
