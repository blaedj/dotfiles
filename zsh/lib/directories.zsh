# Changing/making/removing directory
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
setopt auto_cd

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias 1='cd -'
alias 2='cd -2'

if [[ "$(uname -s)" -eq "Linux" ]]; then
    alias ls="ls --color"
    alias l='ls --color -l --all --human-readable'
    alias ll='ls --color -l --human-readable'
    alias la='ls --color --almost-all --human-readable'
fi

# ls on macos seems not to support long flags..?
if [[ "$(uname -s)" == "Darwin" ]]; then
    alias ls="ls -c"

    if [[ "$(command -v exa)" && $? = 0  ]]; then
        alias ls="exa"
        alias l='exa --long'
        alias la='exa --long --all'
        alias ll='exa --long --all --git'
    fi
fi
