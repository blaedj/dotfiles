PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/tmp/startlog.$$
    setopt xtrace prompt_subst
fi

# Path to your zsh configuration.
export ZSH=$HOME/.dotfiles/zsh
export GOPATH=$HOME/code/go


# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# add a function path
fpath=($ZSH/functions $ZSH/completions $fpath)

# Load all of the config files in $ZSH/lib that end in .zsh
# lib is loaded first so that all files in $ZSH/ can depend
# on the helper functions defined in them.
for config_file ($ZSH/lib/*.zsh); do
    custom_config_file="${ZSH_CUSTOM}/lib/${config_file:t}"
    [ -f "${custom_config_file}" ] && config_file=${custom_config_file}
    source $config_file
done
unset config_file

# Load all of the config files in $ZSH that end in .zsh
# TIP: Add files you don't want in git to .gitignore
for config_file ($ZSH/*.zsh); do
    custom_config_file="${ZSH_CUSTOM}/lib/${config_file:t}"
    [ -f "${custom_config_file}" ] && config_file=${custom_config_file}
    source $config_file
done

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')

is_plugin() {
    local base_dir=$1
    local name=$2
    test -f $base_dir/plugins/$name/$name.plugin.zsh \
        || test -f $base_dir/plugins/$name/_$name
}

# To install the fast-highlighting plugin:
#   git clone https://github.com/zdharma/fast-syntax-highlighting.git \
#       ~/.dotfiles/zsh/plugins/custom/fast-syntax-highlighting
[ -f "$ZSH/plugins/custom/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ] && source "$ZSH/plugins/custom/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# plugins=(git fast-syntax-highlighting)
plugins=(git)

# Add all defined plugins to fpath. This must be done
# before running compinit.
for plugin ($plugins); do
    if is_plugin $ZSH $plugin; then
        fpath=($ZSH/plugins/$plugin $fpath)
    fi
done

# Figure out the SHORT hostname
if [[ "$OSTYPE" = darwin* ]]; then
    # OS X's $HOST changes with dhcp, etc. Use ComputerName if possible.
    SHORT_HOST=$(scutil --get ComputerName 2>/dev/null) || SHORT_HOST=${HOST/.*/}
else
    SHORT_HOST=${HOST/.*/}
fi

# Save the location of the current completion dump file.
if [ -z "$ZSH_COMPDUMP" ]; then
    ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"
fi

# Load and run compinit
autoload -U compinit
compinit -i -d "${ZSH_COMPDUMP}"

# grc (a log colorizer) has built-in support for some commands.
# the following automatically sets some aliases to colorize those commands
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

# fuzzy search/completion utility keeping the fzf config out of this file helps
# with x-platform compat, since the fzf.* files contain paths to where fzf is
# installed
# TODO: the install script should install fzf..
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS_FILE=~/.fzfrc

source ~/.secrets.sh

export EMAIL="me@blaed.org"
export NAME="Blaed Johnston"

# for bat: https://github.com/sharkdp/bat
export BAT_THEME="TwoDark"

# I've given up on the spring preloader for rails
export DISABLE_SPRING=true

# turn on erlang/elixir shell history
export ERL_AFLAGS="-kernel shell_history enabled"

# flyctl!
export FLYCTL_INSTALL="/home/blaed/.fly"

################ PATH modification

addToPathFront() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$1:$PATH
    fi
}

export PATH="$PATH:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$HOME/.dotfiles/bin:$HOME/.local/bin:$HOME/.rbenv/bin:$FLYCTL_INSTALL/bin:$HOME/.docker/bin"

# add go to the path
# export PATH=$PATH:/usr/local/go/bin
# export PATH=$PATH:$GOPATH/bin
addToPathFront $GOPATH/bin

################ /PATH modification

eval "$(rbenv init -)"

# Set the default editor to a custom command, that first tries to use emacsclient, but falls back to vim
export EDITOR="e"

ZSH_THEME="blaed"
source "$ZSH/themes/$ZSH_THEME.zsh"

if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

if command -v ngrok &>/dev/null; then
    eval "$(ngrok completion)"
fi

# source "$ZSH/nvm.zsh"
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# if the file '~/gcp.rc' exists, load it.
# this is configuration for the gcloud sdk tools
if [ -f ~/gcp.rc ]; then
    source ~/gcp.rc
fi

# This needs to run at the very end of the ZSH startup file!
if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
fi
