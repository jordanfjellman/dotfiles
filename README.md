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
5. Symlink Colima socket to Docker socket: (assumed to exist by tools like `devctl`)
   ```shell
   sudo ln -s "$HOME/.colima/default/docker.sock" /var/run/docker.sock
   ```

## ToDo's

- [ ] Decide if the following packages are needed:
  - black
  - dockutil
  - ffmpeg
  - imagemagick
  - lua-language-server
  - luv
  - utf8proc
