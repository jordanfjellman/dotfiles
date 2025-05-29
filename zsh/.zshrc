#!/usr/bin/env zsh

# ZSH Options
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY # Write the history file in the ":start:elapsed;command" format
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS # Remove superfluous blanks before recording entry
setopt HIST_VERIFY # Don't execute immediately upon history expansion
setopt INC_APPEND_HISTORY # write history as soon as they are entered, not when the session is closed

export HISTFILE=$HOME/.zsh_history
export HISTSIZE=100000
export HISTFILESIZE=100000

# Homebrew
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_REPOSITORY="/opt/homebrew";
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

# Shell Autocompletion
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh/site-functions # third-party autoloadable functions
# Only check cache once per day
autoload -Uz compinit
if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
  compinit
else
  compinit -C
fi

# Python
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
function pyenv() {
    unset -f pyenv
    eval "$(command pyenv init -)"
    eval "$(command pyenv virtualenv-init -)"
    pyenv "$@"
}

# Kubernetes
function kubectl() {
    if ! type __start_kubectl >/dev/null 2>&1; then
        source <(command kubectl completion zsh)
    fi
    command kubectl "$@"
}
function stern() {
    if ! type __start_stern >/dev/null 2>&1; then
        source <(command stern --completion=zsh)
    fi
    command stern "$@"
}

# fnm
eval "$(fnm env --use-on-cd --shell zsh)"

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
if type tmux-session-killer &>/dev/null; then
  bindkey -s "^x" "tmux-session-killer\n"
fi

# Set Aliases
alias cat="bat"
alias ls="eza"
alias tree="eza --tree"
alias pr="gh pr create"
alias prv="gh pr view --web"
alias k="kubectl"
alias kl="kubectl login"
alias kns="kubens"
alias kc="kubectx"
alias python="python3"
alias v="vim ."
alias vim="nvim"
alias s="source $HOME/.zprofile && source $HOME/.zshrc"
alias buo="brew update --quiet && brew outdated --quiet"
alias bu="brew upgrade --quiet"
alias sso='_sso() { $(aws configure export-credentials --format env --profile $1) };_sso'
alias g="lazygit"
alias yw="yarn workspace"

# Format json in clipboard
function jj() {
    if [ -p /dev/stdin ]; then
        cat - | jsonpp | pbcopy
    else
        pbpaste | jsonpp | pbcopy
    fi
}

# Setup SDKMAN
#
# Warning: Setting up SDKMAN slows down initializing the shell by about 300ms.
# By temporarily setting the "offline mode" to true, the initial update checks
# are skipped. It's still good to run in online mode (for one, the update
# checks will in other cases), so it should be re-enabled.
#
# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# SDKMAN lazy loading with common Scala/Java tools
for cmd in sdk java mvn sbt scala bloop; do
    eval "function $cmd() {
        unset -f $cmd
        export SDKMAN_DIR=\"\$HOME/.sdkman\"
        export SDKMAN_OFFLINE_MODE=true
        [[ -s \"\$SDKMAN_DIR/bin/sdkman-init.sh\" ]] && source \"\$SDKMAN_DIR/bin/sdkman-init.sh\"
        command $cmd \"\$@\"
    }"
done
export PYTHON=/usr/bin/python3
