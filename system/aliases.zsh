# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
# if $(gls &>/dev/null)
# then
#   alias ls="gls -F --color"
#   alias l="gls -lAh --color"
#   alias ll="gls -l --color"
#   alias la='gls -A --color'
# fi

alias git-head="git log --oneline --no-color | head -n 1 | awk '{print $1}'"
alias fd='fd-find'
