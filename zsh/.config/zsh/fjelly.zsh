# zsh/fjelly.zsh - fjelly integration for zsh

# Ensure fjelly is in PATH
if [[ -d "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Alias to update fjelly from source
alias fjelly-update="$HOME/.local/bin/update-fjelly"

# Function to cd into fjelly source directory
cdfj() {
    cd "$HOME/code/personal/fjelly" || return 1
}

# Completion setup (if zsh completions are available)
if [[ -d "$HOME/.config/zsh/completions" ]]; then
    fpath+=("$HOME/.config/zsh/completions")
fi

# Optional: Auto-update check (uncomment to enable)
# if command -v fjelly &> /dev/null; then
#     # Check once per day
#     if [[ ! -f "$HOME/.cache/fjelly-last-check" ]] || \
#        [[ $(find "$HOME/.cache/fjelly-last-check" -mtime +1) ]]; then
#         echo "[fjelly] Consider running 'fjelly-update' if it's been a while"
#         touch "$HOME/.cache/fjelly-last-check"
#     fi
# fi
