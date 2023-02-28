#!/usr/bin/env zsh

# Homebrew
#
# "brew" is used in this script, so it needs to be set early
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_ANALYTICS=1

# Python Environment Manager
#
# Warning: Intentionally disabled; adds an additional 1.5s to shell init.
local disable_python_env=true
if [ "$disable_python_env" = false ] && command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi
unset disable_python_env

# Shell Autocompletion
#
# Warning: Setting up auto completion slows down initializing the shell about 500ms.
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh/site-functions # third-party autoloadable functions
autoload -Uz compinit
compinit
# Temporarily removed; zsh-completions appears to be largely unused.
# if type brew &>/dev/null; then
  # FPATH=$(brew --prefix)/share/zsh-completions:$FPATH # takes about 200ms
# fi
if type kubectl &>/dev/null; then
  source <(kubectl completion zsh)
fi

# fnm
eval "$(fnm env --use-on-cd)"

# fzf
export FZF_DEFAULT_OPS="--extended"
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Helm
export HELM_HOME="$HOME/.helm"

# Jest
export DEBUG_PRINT_LIMIT=10000

# Okta
if [[ -f "$HOME/.okta/bash_functions" ]]; then
    . "$HOME/.okta/bash_functions"
fi
if [[ -d "$HOME/.okta/bin" && ":$PATH:" != *":$HOME/.okta/bin:"* ]]; then
    PATH="$HOME/.okta/bin:$PATH"
fi

# Starship Prompt
eval "$(starship init zsh)"

# Tmux
export ZSH_TMUX_AUTOSTART=true

# Bind Keys
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey -s "M-f" vi-backward-blank-word
bindkey -s "M-b" vi-forward-blank-word
if type tmux-sessionizer &>/dev/null; then
  bindkey -s "^f" "tmux-sessionizer\n"
fi

# Set Aliases
alias cat="bat"
alias ls="exa"
alias tree="exa --tree"
alias gd="github ."
alias pr="gh pr create"
alias prv="gh pr view --web"
alias k="kubectl"
alias kl="kubectl login"
alias kns="kubens"
alias kc="kubectx"
alias v="vim ."
alias vim="nvim"
alias s="source $HOME/.zprofile && source $HOME/.zshrc"

# Setup SDKMAN
#
# Warning: Setting up SDKMAN slows down initializing the shell by about 300ms.
# By temporarily setting the "offline mode" to true, the initial update checks
# are skipped. It's still good to run in online mode (for one, the update
# checks will in other cases), so it should be re-enabled.
#
# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
local original_sdkman_offline_mode=${SDKMAN_OFFLINE_MODE:-}
export SDKMAN_OFFLINE_MODE=true
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh" 
if [[ -n $original_sdkman_offline_mode ]]; then
  export SDKMAN_OFFLINE_MODE=$original_sdkman_offline_mode
else
  unset SDKMAN_OFFLINE_MODE
fi
unset original_sdkman_offline_mode
