#!/usr/bin/env zsh
PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:/usr/local/sbin:/Users/jfjellm/Library/Application\ Support/Coursier/bin:/usr/local/opt/kafka/bin:/usr/local/opt/ruby/bin:$PATH

# Add binaries for kubectl plugin manager, krew
PATH="${PATH}:${HOME}/.krew/bin"

# Add binaries for python environment manager
export PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"

export PATH

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

alias vim="nvim"
export EDITOR="nvim"
export HISTSIZE=10000

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_ANALYTICS=1

# fzf
export FZF_DEFAULT_OPS="--extended"
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"

# tmux-sessionizer
bindkey -s "^f" "tmux-sessionizer\n"
bindkey -s "^n" "tmux-sessionizer \"$HOME/notes\" \n"

# line navigation
bindkey -s "M-f" vi-backward-blank-word
bindkey -s "M-b" vi-forward-blank-word

# nvm configuration
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] &&
  printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME/nvm}")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

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

# python
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

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
alias gd="github ."
alias pr="gh pr create"
alias prv="gh pr view --web"
alias k="kubectl"
alias kl="kubectl login"
alias kns="kubens"
alias kc="kubectx"
alias v="vim ."
