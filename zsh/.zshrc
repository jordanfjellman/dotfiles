export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"
ZSH_TMUX_AUTOSTART=true

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh/site-functions

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit
fi

source $ZSH/oh-my-zsh.sh

plugins=(
  brew
  git
  github
  tmux
  zsh-autosuggestions
  zsh-completions
)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# tmux-sessionizer
bindkey -s "^f" "tmux-sessionizer\n"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
