#!/usr/bin/env fish

# Shell Settings
set -gx fish_greeting # no greeting message
set -gx EDITOR nvim
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx XDG_CONFIG_HOME $HOME/.config

# Homebrew
set -gx HOMEBREW_PREFIX /opt/homebrew
set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/homebrew"
set -gx HOMEBREW_NO_ANALYTICS 1

# PATH
fish_add_path -gP "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin"
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/Library/Application Support/Coursier/bin
fish_add_path /Applications/Obsidian.app/Contents/MacOS

# MANPATH and INFOPATH
! set -q MANPATH; and set MANPATH ''
set -gx MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH

! set -q INFOPATH; and set INFOPATH ''
set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH

# mise
# set -gx MISE_NODE_COMPILE 0
mise activate fish | source

# fzf
set -gx FZF_DEFAULT_OPS --extended
set -gx FZF_CTRL_T_COMMAND "fd --type f"
fzf --fish | source

# Jest
set -gx DEBUG_PRINT_LIMIT 10000

# Source private keys if they exist
if test -f $HOME/.private_keys
    source $HOME/.private_keys
end

# Function to load standard KEY=value env files into Fish
function load_env
    if test (count $argv) -lt 1
        echo "Usage: load_env <env_file>"
        return 1
    end
    
    set -l env_file $argv[1]
    
    if not test -f $env_file
        echo "Error: File not found: $env_file"
        return 1
    end
    
    while read -l line
        # Skip empty lines and comments
        if test -z (string trim -- $line); or string match -q '#*' -- $line
            continue
        end
        
        # Parse KEY=value format
        # Find the first = to split key and value
        if string match -q '*=*' -- $line
            set -l key (string split -m 1 '=' $line)[1]
            set -l value (string split -m 1 '=' $line)[2]
            
            # Trim whitespace and quotes
            set key (string trim -- $key)
            set value (string trim -- $value)
            
            # Remove surrounding quotes if present
            set value (string trim -c '"' -- $value)
            set value (string trim -c "'" -- $value)
            
            # Export the variable globally
            set -gx $key $value
        end
    end <$env_file
end

# Source skills configuration if it exists
if test -f $HOME/.secrets/skills.env
    load_env $HOME/.secrets/skills.env
end

# Initialize starship prompt
if command -q starship
    function starship_transient_prompt_func
        starship module character
    end
    starship init fish | source
    enable_transience
end

# Key bindings
bind \ca beginning-of-line
bind \ce end-of-line
bind \ew 'fj pick; commandline -f repaint'

# Functions
function pr
    gh pr create $argv
end

function prv
    gh pr view --web $argv
end

function submit_mobile
    gh workflow run mobile.submit-to-testflight.yml --repo lifewayit/lifeway-discipleship && gh workflow run mobile.submit-to-play-store.yml --repo lifewayit/lifeway-discipleship
end

function submit_tv
    gh workflow run tv.submit-to-testflight.yml --repo lifewayit/lifeway-discipleship && gh workflow run tv.submit-to-play-store.yml --repo lifewayit/lifeway-discipleship && gh workflow run tv.submit-to-amazon-appstore.yml --repo lifewayit/lifeway-discipleship
end

function up_homebrew
  set brewfile_dir ~/code/personal/dotfiles
  set tmp_brewfile (mktemp)
  cat $brewfile_dir/Brewfile.common > $tmp_brewfile
  if is_home_machine
    cat $brewfile_dir/Brewfile.home >> $tmp_brewfile
  else
    cat $brewfile_dir/Brewfile.work >> $tmp_brewfile
  end
  brew bundle --file=$tmp_brewfile
  brew bundle cleanup --file=$tmp_brewfile --cleanup --force
  rm $tmp_brewfile

  brew update --quiet
  brew outdated --quiet
  brew upgrade --quiet
  brew cleanup --prune=all
end

function up_mise
  mise up
  mise prune --yes
end

function up_repos
  set -l repos ~/code/personal/dotfiles ~/code/personal/skills

  for repo in $repos
    if not test -d $repo/.git
      echo "⚠️  Warning: $repo is not a git repository, skipping..."
      continue
    end

    set -l git_status (git -C $repo status --porcelain 2>/dev/null)
    if test -n "$git_status"
      echo "⚠️  Warning: $repo has uncommitted changes, skipping..."
      continue
    end

    echo "📥 Updating $repo..."
    git -C $repo pull --ff-only 2>/dev/null || git -C $repo pull
  end
end

function is_home_machine
    set -l home_hosts "MacBookPro" "fjellymac.local"
    if contains (hostname) $home_hosts
        return 0
    end
    return 1
end

function up_skills
  set -l skills_file ~/.secrets/skills.txt

  # Sync from Bitwarden Secrets Manager first (if configured)
  if test -n "$SKILLS_CONFIG"; and test -n "$BWS_ACCESS_TOKEN"
    echo "⬇️  Syncing skills config from Bitwarden Secrets Manager..."

    # Find the secret by name
    set -l secret_json (bws secret list --output json 2>/dev/null | jq -r ".[] | select(.key == \"$SKILLS_CONFIG\")" 2>/dev/null)

    if test -z "$secret_json"
      echo "❌ Error: Secret '$SKILLS_CONFIG' not found in Bitwarden Secrets Manager."
      echo "Please create the secret first in the 'Skills' project or check your configuration."
      return 1
    end

    set -l secret_value (echo "$secret_json" | jq -r '.value')

    # Decode base64 and write to file
    echo "$secret_value" | openssl base64 -d -out "$skills_file"
    if test $status -ne 0
      echo "❌ Error: Failed to decode secret value from Bitwarden."
      return 1
    end

    echo "✅ Skills config synced from Bitwarden"
  end

  if not test -f $skills_file
    echo "❌ Error: Skills configuration file not found at $skills_file"
    echo "Create the file and add skills in the format:"
    echo "  git@github.com:owner/repo.git --skill skill-name"
    return 1
  end

  echo "🧹 Cleaning up previous installations..."
  npx skills remove --global --all --yes

  echo "📦 Installing skills from $skills_file..."

  # Read all lines from file into array first (avoids stdin conflicts with npx)
  set -l all_lines (cat "$skills_file")

  # Process each line
  for line in $all_lines
    # Skip empty lines and comments
    if test -z "$line"; or string match -q '#*' -- $line
      continue
    end

    # Trim leading/trailing whitespace
    set -l trimmed (string trim -- $line)

    # Skip if trimmed line is empty or a comment
    if test -z "$trimmed"; or string match -q '#*' -- $trimmed
      continue
    end

    # Split line into arguments (repo URL and flags)
    set -l args (string split ' ' -- $trimmed)

    echo "➡️  Installing: $trimmed"
    npx skills add $args[1] $args[2] $args[3] --global --yes
    if test $status -ne 0
      echo "❌ Error: Failed to install skill: $trimmed"
      echo "Comment out this line in $skills_file to skip it."
      return 1
    end
  end

  echo "📦 Updating skills to latest versions..."
  npx skills update --global

  echo "✅ Skills updated successfully"
end

function up
  up_repos
  up_skills
  up_homebrew
  up_mise
end

function sync_skills_up
  set -l skills_file ~/.secrets/skills.txt

  # Check if SKILLS_CONFIG is set
  if test -z "$SKILLS_CONFIG"
    echo "❌ Error: SKILLS_CONFIG is not set."
    echo "Set it in ~/.secrets/skills.env to the Bitwarden secret name."
    return 1
  end

  # Check if Bitwarden Secrets Manager access token is set
  if test -z "$BWS_ACCESS_TOKEN"
    echo "❌ Error: BWS_ACCESS_TOKEN is not set."
    echo "Set it in ~/.secrets/skills.env with your machine account access token."
    return 1
  end

  # Check if skills file exists
  if not test -f $skills_file
    echo "❌ Error: Skills file not found at $skills_file"
    return 1
  end

  # Read and base64 encode file content (preserves newlines and special characters)
  set -l encoded_content (openssl base64 -in "$skills_file" | tr -d '\n')

  # Find the secret by name in the Skills project
  set -l secret_json (bws secret list --output json 2>/dev/null | jq -r ".[] | select(.key == \"$SKILLS_CONFIG\")" 2>/dev/null)

  if test -z "$secret_json"
    echo "❌ Error: Secret '$SKILLS_CONFIG' not found in Bitwarden Secrets Manager."
    echo "Please create the secret first in the 'Skills' project."
    return 1
  end

  set -l secret_id (echo "$secret_json" | jq -r '.id')

  # Update secret value with base64 encoded content
  echo "⬆️  Uploading $skills_file to Bitwarden secret '$SKILLS_CONFIG'..."
  bws secret edit "$secret_id" --value "$encoded_content" 2>/dev/null
  if test $status -ne 0
    echo "❌ Error: Failed to update secret."
    return 1
  end

  echo "✅ Skills config uploaded successfully to Bitwarden Secrets Manager"
end

function sync_skills_down
  set -l skills_file ~/.secrets/skills.txt

  # Check if SKILLS_CONFIG is set
  if test -z "$SKILLS_CONFIG"
    echo "❌ Error: SKILLS_CONFIG is not set."
    echo "Set it in ~/.secrets/skills.env to the Bitwarden secret name."
    return 1
  end

  # Check if Bitwarden Secrets Manager access token is set
  if test -z "$BWS_ACCESS_TOKEN"
    echo "❌ Error: BWS_ACCESS_TOKEN is not set."
    echo "Set it in ~/.secrets/skills.env with your machine account access token."
    return 1
  end

  # Find the secret by name
  set -l secret_json (bws secret list --output json 2>/dev/null | jq -r ".[] | select(.key == \"$SKILLS_CONFIG\")" 2>/dev/null)

  if test -z "$secret_json"
    echo "❌ Error: Secret '$SKILLS_CONFIG' not found in Bitwarden Secrets Manager."
    echo "Please create the secret first in the 'Skills' project."
    return 1
  end

  set -l secret_value (echo "$secret_json" | jq -r '.value')

  # Decode base64 and write to file
  echo "⬇️  Downloading skills config from Bitwarden..."
  echo "$secret_value" | openssl base64 -d -out "$skills_file"
  if test $status -ne 0
    echo "❌ Error: Failed to decode secret value."
    return 1
  end

  echo "✅ Skills config downloaded to $skills_file"
end

function kiro-login
  kiro-cli login --use-device-flow --license=pro --identity-provider=https://lifeway.awsapps.com/start --region=us-east-1
end

function k
    kubectl $argv
end

function kl
    devctl k8s login
end

function kns
    kubens $argv
end

function kc
    kubectx $argv
end

function v
    nvim $argv
end

function fj
    fjelly $argv
end

function cat
    bat --style=plain $argv
end

function tree
    eza --tree --all --group-directories-first $argv
end

function ls
    eza --all --group-directories-first $argv
end

function devctl
    /usr/local/lib/devctl/bin/run.js $argv
end

function sso
    if test (count $argv) -eq 0
        echo "Usage: sso <profile>"
        return 1
    end
    eval (aws configure export-credentials --format env --profile $argv[1])
end

function start-kiro-gateway 
  set -l container_name kiro-gateway
  docker rm -f $container_name &>/dev/null
  docker run -d -p 9111:8000 \
    -v ~/Library/Application\ Support/kiro-cli:/home/kiro/.local/share/kiro-cli:ro \
    -e KIRO_CLI_DB_FILE=/home/kiro/.local/share/kiro-cli/data.sqlite3 \
    -e PROXY_API_KEY="$(cat ~/.secrets/kiro-gateway-password)" \
    --name $container_name \
    ghcr.io/jwadow/kiro-gateway:latest
end

function docker-rm-all-by-image
    if test (count $argv) -eq 0
        echo "Usage: docker-rm-all-by-image <image>"
        return 1
    end
  docker rm -f $(docker ps -q --filter "$argv[1]")
end

function espanso-update
  espanso install lw-snippets --git git@github.com:LifewayIT/lw-snippets.git --external --force
  espanso restart
end

# fjellyspaces — ephemeral agent workspaces
# fj is the binary name; this ensures the alias works when installed to ~/.local/bin
if not type -q fj
    if test -f "$HOME/.cargo/bin/fj"
        fish_add_path "$HOME/.cargo/bin"
    end
end
