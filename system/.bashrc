# this is only here because when launching bash from zsh, bash tries to read
# `PS1` from the env, and my zsh PS1 has these functions in it.
function git_info_for_prompt {
    echo ""
    return
}

function git_prompt_info {
    echo ""
    return
}

function git_remote_status {
    echo ""
    return
}


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
