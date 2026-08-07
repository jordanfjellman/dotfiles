#!/usr/bin/env bash
# Test neovim config health in headless mode
# Usage:
#   ./test/run_health.sh              # test all filetypes
#   ./test/run_health.sh lua          # test specific filetype
#   ./test/run_health.sh typescript go rust

set -euo pipefail

NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

HEALTH_SCRIPT="$SCRIPT_DIR/health_check.lua"

if [[ ! -f "$HEALTH_SCRIPT" ]]; then
  echo "Error: health_check.lua not found at $HEALTH_SCRIPT"
  exit 1
fi

echo "Running neovim config health check..."
echo "Config: $NVIM_CONFIG_DIR"
echo ""

# Use --headless +luafile pattern so plugins load before our script runs
if [[ $# -gt 0 ]]; then
  # Pass filetypes via env var since +luafile doesn't support args easily
  HEALTH_CHECK_FTS="$*" nvim --headless +"lua vim.defer_fn(function() dofile('$HEALTH_SCRIPT') end, 2000)" 2>&1
else
  nvim --headless +"lua vim.defer_fn(function() dofile('$HEALTH_SCRIPT') end, 2000)" 2>&1
fi
