# zsh/fjelly.zsh - fjelly integration for zsh

# Ensure fjelly is in PATH
if [[ -d "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Function to cd into fjelly source directory
cdfj() {
    cd "$HOME/code/personal/fjelly" || return 1
}

# Completion setup (if zsh completions are available)
if [[ -d "$HOME/.config/zsh/completions" ]]; then
    fpath+=("$HOME/.config/zsh/completions")
fi
