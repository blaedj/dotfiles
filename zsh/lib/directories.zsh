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

# List directory contents
alias ls="ls --color"
alias l='ls --color -l --all --human-readable'
alias ll='ls --color -l --human-readable'
alias la='ls --color --almost-all --human-readable'
