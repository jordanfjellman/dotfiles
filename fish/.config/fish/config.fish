#!/usr/bin/env fish

# Shell Settings
set -gx EDITOR nvim
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx XDG_CONFIG_HOME $HOME/.config

# Homebrew
set -gx HOMEBREW_PREFIX /opt/homebrew
set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_REPOSITORY /opt/homebrew

# MANPATH and INFOPATH
set -gx MANPATH /opt/homebrew/share/man $MANPATH
set -gx INFOPATH /opt/homebrew/share/info $INFOPATH

# fzf
set -gx FZF_DEFAULT_OPS --extended
set -gx FZF_CTRL_T_COMMAND "fd --type f"
fzf --fish | source

# Helm
set -gx HELM_HOME $HOME/.helm

# Jest
set -gx DEBUG_PRINT_LIMIT 10000

# Java
set -gx JAVA_HOME /Users/jordan.fjellman/.sdkman/candidates/java/17.0.10-amzn

# Tmux
set -gx ZSH_TMUX_AUTOSTART true

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

# Custom key bindings for tmux tools
if command -q tmux-sessionizer
    bind \cf 'tmux-sessionizer; commandline -f repaint'
end

if command -q tmux-session-killer
    bind \cx 'tmux-session-killer; commandline -f repaint'
end

# Load lazy functions
source $__fish_config_dir/conf.d/lazy_loading.fish

# Functions
function pr
    gh pr create $argv
end

function prv
    gh pr view --web $argv
end

function submit_apps
    gh pr workflow run mobile.submit-to-testflight.yml --repo lifewayit/lifeway-discipleship && gh pr workflow run mobile.submit-to-play-store.yml --repo lifewayit/lifeway-discipleship
end

function g
    lazygit $argv
end

function buo
    brew update --quiet && brew outdated --quiet
end

function bu
    brew upgrade --quiet
end
