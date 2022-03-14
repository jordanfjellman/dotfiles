#!/usr/bin/env zsh
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/opt/python@3.8/bin:/Users/jfjellm/Library/Application\ Support/Coursier/bin:/usr/local/opt/kafka/bin:/usr/local/opt/ruby/bin:$PATH

alias vim="nvim"
export EDITOR="nvim"
export HISTSIZE=10000

# homebrew
export HOMEBREW_NO_ANALYTICS=1

# fzf
export FZF_DEFAULT_OPS="--extended"
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"

# tmux-sessionizer
bindkey -s "^f" "tmux-sessionizer\n"

# nvm configuration
export NVM_DIR="$HOME/.nvm"
  . "/usr/local/opt/nvm/nvm.sh"

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# java environment
export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
alias java8='export JAVA_HOME=$JAVA_8_HOME'
export JAVA_11_HOME=$(/usr/libexec/java_home -v11)
alias java11='export JAVA_HOME=$JAVA_11_HOME'
export JAVA_HOME=$JAVA_11_HOME

# helm
export HELM_HOME="$HOME/.helm"

# jest
export DEBUG_PRINT_LIMIT=10000

# okta
if [[ -f "$HOME/.okta/bash_functions" ]]; then
    . "$HOME/.okta/bash_functions"
fi
if [[ -d "$HOME/.okta/bin" && ":$PATH:" != *":$HOME/.okta/bin:"* ]]; then
    PATH="$HOME/.okta/bin:$PATH"
fi

if [[ -f "$HOME/.private_keys" ]]; then
  source $HOME/.private_keys
fi

# aliases
alias pr="gh pr create"
alias k="kubectl"
alias kl="kubectl login"
alias kns="kubens"
alias kc="kubectx"
alias v="vim ."
