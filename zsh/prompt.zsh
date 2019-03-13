autoload colors && colors
# ZSH theme based on 'intheloop' by James Smith (http://loopj.com)
# A multiline prompt with username, hostname, full path, return status, git branch, git dirty status, git remote status

local return_status="%{$fg[red]%}%(?..⏎)%{$reset_color%}"

local host_color="green"
if [ -n "$SSH_CLIENT" ]; then
  local host_color="red"
fi

PROMPT="
%{$fg_bold[grey]%}[%{$reset_color%}%{$fg_bold[${host_color}]%}%n@%m%{$reset_color%}%{$fg_bold[grey]%}]%{$reset_color%} %{$fg_bold[blue]%}%2~%{$reset_color%} $(git_prompt_info) $(git_remote_status)
%{$fg[cyan]%}›%{$reset_color%} "
#%{$fg_bold[cyan]%}❯%{$reset_color%} '

RPROMPT="${return_status}%{$reset_color%}${time}"

# local time, color coded by last return code
#time_enabled="%(?.%{$fg[green]%}.%{$fg[red]%})%*%{$reset_color%}" # time: timestamp style
time_enabled="%(?.%{$fg[green]%}.%{$fg[red]%})%t%{$reset_color%}"
time_disabled="%{$fg[green]%}%t%{$reset_color%}"
time=$time_enabled
# cool characters: ⚡ ➟❯

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[grey]%}[%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[grey]%}] %{$fg_bold[yellow]%}✗✗✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[grey]%}]"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="%{$fg_bold[magenta]%}↓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$fg_bold[magenta]%}↑%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="%{$fg_bold[magenta]%}↕%{$reset_color%}"
