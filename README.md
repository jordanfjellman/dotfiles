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
6. Link the herdr worktree-env plugin (per machine; herdr records it in its own registry, so stow can't):
   ```shell
   herdr plugin link ~/code/personal/dotfiles/herdr/.config/herdr/plugins/worktree-env
   ```

## Keeping Machines Up To Date

`up` runs every `up-*` unit it finds on PATH. `up -n` reports what is out of
date and changes nothing. `up nvim brew` runs only those units.

A unit takes no args to apply, `-n` to report, and exits 0 clean, 2 drift, 1
failed. Adding a unit means adding one `up-<thing>` to `bin/.local/bin/` and
nothing else — `up` finds it.

`machine-profile` prints `home` or `work`. It fails on an unknown host on
purpose, because `up-brew` picks a Brewfile from it and then runs `brew bundle
cleanup`, which uninstalls whatever that Brewfile omits.

## Default Shell

I prefer to use `fish` as my default shell. To do this, I first need to add Fish an acceptable shell, then set it for my user:

```shell
echo $(brew --prefix)/bin/fish | sudo tee -a /etc/shells
```

```shell
chsh -s $(brew --prefix)/bin/fish
```

## Figma MCP OAuth Registration

Figma whitelists MCP clients by `client_name`. To register credentials for OpenCode, use the `"Claude Code (figma)"` client name ([source](https://github.com/anomalyco/opencode/issues/988#issuecomment-4022520800)):

```shell
curl -s -X POST https://api.figma.com/v1/oauth/mcp/register \
  -H "Content-Type: application/json" \
  -d '{
    "client_name": "Claude Code (figma)",
    "redirect_uris": ["http://127.0.0.1:19876/mcp/oauth/callback"],
    "grant_types": ["authorization_code", "refresh_token"],
    "response_types": ["code"],
    "token_endpoint_auth_method": "none"
  }' | tee /tmp/figma-reg.json | jq -r '.client_id' > ~/.secrets/figma-client-id \
    && jq -r '.client_secret' < /tmp/figma-reg.json > ~/.secrets/figma-client-secret \
    && rm /tmp/figma-reg.json
```

Then run `opencode mcp auth figma` and accept the browser prompts.

## ToDo's

- [ ] Decide if the following packages are needed:
  - black
  - dockutil
  - ffmpeg
  - imagemagick
  - lua-language-server
  - luv
  - utf8proc
