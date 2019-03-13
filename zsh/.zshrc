# Path to your zsh configuration.
export ZSH=$HOME/.dotfiles/zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="blaed"

alias ll="ls -lh"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

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

# Load all of the config files in ~/oh-my-zsh that end in .zsh
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

plugins=(git themes bundler fast-syntax-highlighting)
# Add all defined plugins to fpath. This must be done
# before running compinit.
for plugin ($plugins); do
    if is_plugin $ZSH_CUSTOM $plugin; then
        fpath=($ZSH_CUSTOM/plugins/$plugin $fpath)
    elif is_plugin $ZSH $plugin; then
        fpath=($ZSH/plugins/$plugin $fpath)
    fi
done

# grc (a log colorizer) has built-in support for some commands.
# the following automatically sets some aliases to colorize those commands
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh


# for bat: https://github.com/sharkdp/bat
export BAT_THEME="TwoDark"



# source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
