#!/usr/bin/env zsh

# Shell Settings
export EDITOR="nvim"
export HISTSIZE=10000
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Set binary paths
PATH="$HOME/bin:/usr/local/bin:$HOME/.local/bin:/usr/local/sbin::$PATH"
PATH="$PATH:/usr/local/opt/ruby/bin"
PATH="$PATH:/usr/local/opt/kafka/bin"
PATH="$PATH:$HOME/.krew/bin" # Add binaries for kubectl plugin manager, krew

# Add binaries for python environment manager
export PYENV_ROOT="$HOME/.pyenv"
PATH="$PATH:$PYENV_ROOT/bin"

# Add binaries for coursier (scala)
PATH="$PATH:$HOME/Library/Application Support/Coursier/bin"

# Add binaries for okta (assume aws role)
PATH="$PATH:$HOME/.okta/bin"

# Add android sdk and platform tools
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export ANDROID_AVD_HOME=$HOME/.android/avd
PATH="$PATH:$ANDROID_HOME/platform-tools"

export PATH

# Source private keys
if [[ -f "$HOME/.private_keys" ]]; then
  source $HOME/.private_keys
fi
