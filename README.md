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
