# Dotfiles

1. Install the applications via Homebrew: `brew bundle install`
2. Install the stowed directories using `./install`.
3. Run `/opt/homebrew/opt/tpm/share/tpm/tpm` and install tmux plugins via `prefix + I`.
4. Install Scala specific plugins via Coursier:
   ```shell
   cs install metals
   cs install scalafix
   cs install scalafmt
   ```
