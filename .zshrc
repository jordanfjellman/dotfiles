# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

plugins=(
  git
  colored-man
  colorize github
  jira
  brew
  osx 
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# sdkman
# This must be at the end of the file for sdkman to work
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
