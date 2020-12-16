
bindkey '^r' history-incremental-search-backward      # [Ctrl-r] - Search backward incrementally for a specified string.

if [[ "${terminfo[kcuu1]}" != "" ]]; then
    bindkey "${terminfo[kcuu1]}" up-line-or-search      # start typing + [Up-Arrow] - fuzzy find history forward
fi
if [[ "${terminfo[kcud1]}" != "" ]]; then
    bindkey "${terminfo[kcud1]}" down-line-or-search    # start typing + [Down-Arrow] - fuzzy find history backward
fi

if [[ "${terminfo[khome]}" != "" ]]; then
    bindkey "${terminfo[khome]}" beginning-of-line      # [Home] - Go to beginning of line
fi
if [[ "${terminfo[kend]}" != "" ]]; then
    bindkey "${terminfo[kend]}"  end-of-line            # [End] - Go to end of line
fi


# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line
