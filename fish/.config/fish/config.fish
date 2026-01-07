#!/usr/bin/env fish

# Shell Settings
set -gx fish_greeting # no greeting message
set -gx EDITOR nvim
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx XDG_CONFIG_HOME $HOME/.config

# PATH
fish_add_path /opt/homebrew/bin
fish_add_path $HOME/.cargo/bin

# Homebrew
set -gx HOMEBREW_PREFIX /opt/homebrew
set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_REPOSITORY /opt/homebrew

# MANPATH and INFOPATH
set -gx MANPATH /opt/homebrew/share/man $MANPATH
set -gx INFOPATH /opt/homebrew/share/info $INFOPATH

# mise
# set -gx MISE_NODE_COMPILE 0
mise activate fish | source

# fzf
set -gx FZF_DEFAULT_OPS --extended
set -gx FZF_CTRL_T_COMMAND "fd --type f"
fzf --fish | source

# Jest
set -gx DEBUG_PRINT_LIMIT 10000

# Java
set -gx JAVA_HOME /Users/jordan.fjellman/.sdkman/candidates/java/17.0.10-amzn

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

# Functions
function pr
    gh pr create $argv
end

function prv
    gh pr view --web $argv
end

function submit_mobile
    gh workflow run mobile.submit-to-testflight.yml --repo lifewayit/lifeway-discipleship && gh workflow run mobile.submit-to-play-store.yml --repo lifewayit/lifeway-discipleship
end

function submit_tv
    gh workflow run tv.submit-to-testflight.yml --repo lifewayit/lifeway-discipleship && gh workflow run tv.submit-to-play-store.yml --repo lifewayit/lifeway-discipleship
end

function buo
    brew update --quiet && brew outdated --quiet
end

function bu
    brew upgrade --quiet
end

function k
    kubectl $argv
end

function kl
    kubectl login
end

function kns
    kubens $argv
end

function kc
    kubectx $argv
end

function v
    nvim $argv
end

function cat
    bat --style=plain $argv
end

function tree
    exa --tree --all --group-directories-first $argv
end

function ls
    exa --all --group-directories-first $argv
end

function devctl
    /usr/local/lib/devctl/bin/run.js $argv
end
