#!/usr/bin/env fish

# Shell Settings
set -gx fish_greeting # no greeting message
set -gx EDITOR nvim
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx XDG_CONFIG_HOME $HOME/.config

# Homebrew
set -gx HOMEBREW_PREFIX /opt/homebrew
set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/homebrew"
set -gx HOMEBREW_NO_ANALYTICS 1

# PATH
fish_add_path -gP "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin"
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/Library/Application Support/Coursier/bin
fish_add_path $HOME/.lmstudio/bin
fish_add_path /Applications/Obsidian.app/Contents/MacOS

# MANPATH and INFOPATH
! set -q MANPATH; and set MANPATH ''
set -gx MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH

! set -q INFOPATH; and set INFOPATH ''
set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH

# mise
mise activate fish | source

# fzf
set -gx FZF_DEFAULT_OPS --extended
set -gx FZF_CTRL_T_COMMAND "fd --type f"
fzf --fish | source

# Jest
set -gx DEBUG_PRINT_LIMIT 10000

# Delete this and CoCo ignores the config the agents repo stows under this path
set -gx SNOWFLAKE_HOME $XDG_CONFIG_HOME/snowflake

# pi
set -gx PI_SKIP_VERSION_CHECK 1
set -gx PI_OFFLINE 1

# Source private keys if they exist
if test -f $HOME/.private_keys
    source $HOME/.private_keys
end

# Initialize starship prompt
if command -q starship
    function starship_transient_prompt_func
        starship module character
    end
    starship init fish | source
    enable_transience
end

# Key bindings
bind \ca beginning-of-line
bind \ce end-of-line
if type -q tmux-sessionizer
    bind \cf 'tmux-sessionizer; commandline -f repaint'
end
