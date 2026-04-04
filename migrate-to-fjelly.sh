#!/bin/bash
# Migration script: fjellyspaces -> fjelly
# This script automates the migration process

set -e  # Exit on error

echo "🚀 Starting fjellyspaces -> fjelly migration"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

DOTFILES_DIR="$HOME/code/personal/dotfiles"

# Step 1: Commit changes to git
echo -e "${YELLOW}Step 1: Committing changes to git...${NC}"
cd "$DOTFILES_DIR"

echo "  → Adding modified files..."
git add mise/.config/mise/config.toml install fjelly/

echo "  → Creating commit..."
git commit -m "feat: migrate from fjellyspaces to fjelly

- Update mise to install fjelly instead of fjellyspaces
- Create new fjelly stow directory with updated config paths  
- Update install script to stow fjelly instead of fjellyharness/fjellyspaces
- Config paths updated from ~/.local/share/fjellyspaces/ to ~/.local/share/fjelly/"

echo -e "${GREEN}✓ Changes committed${NC}"
echo ""

# Step 2: Unstow old, stow new
echo -e "${YELLOW}Step 2: Unstowing fjellyspaces and stowing fjelly...${NC}"
cd "$DOTFILES_DIR"

echo "  → Unstowing fjellyspaces..."
if /opt/homebrew/bin/stow --delete fjellyspaces 2>/dev/null; then
    echo -e "${GREEN}✓ fjellyspaces unstowed${NC}"
else
    echo -e "${YELLOW}⚠ fjellyspaces was not stowed or already removed${NC}"
fi

echo "  → Stowing fjelly..."
/opt/homebrew/bin/stow --target=$HOME fjelly
echo -e "${GREEN}✓ fjelly stowed${NC}"

echo ""

# Step 3: Install fjelly via mise (using github backend like fjellyspaces)
echo -e "${YELLOW}Step 3: Installing fjelly via mise...${NC}"

echo "  → Trusting fjelly tool..."
mise trust github:jordanfjellman/fjelly 2>/dev/null || true

echo "  → Installing fjelly..."
mise install github:jordanfjellman/fjelly

echo "  → Setting as global tool..."
mise use -g github:jordanfjellman/fjelly

echo "  → Generating completions..."
# Fish completions
if [ -d "$HOME/.config/fish/completions" ]; then
    mise exec github:jordanfjellman/fjelly -- fjelly completions fish > "$HOME/.config/fish/completions/fjelly.fish" 2>/dev/null || true
fi

echo -e "${GREEN}✓ fjelly installed via mise${NC}"
echo ""

# Step 4: Verify installation
echo -e "${YELLOW}Step 4: Verifying installation...${NC}"

# Check 1: Config symlink exists
if [ -L "$HOME/.config/fjelly" ]; then
    echo -e "${GREEN}✓ ~/.config/fjelly is symlinked${NC}"
else
    echo -e "${RED}✗ ~/.config/fjelly is not symlinked${NC}"
fi

# Check 2: Config file is readable
if [ -f "$HOME/.config/fjelly/config.toml" ]; then
    echo -e "${GREEN}✓ ~/.config/fjelly/config.toml exists${NC}"
else
    echo -e "${RED}✗ ~/.config/fjelly/config.toml not found${NC}"
fi

# Check 3: fjelly binary is available
if command -v fjelly &> /dev/null; then
    echo -e "${GREEN}✓ fjelly binary is in PATH${NC}"
    echo "  → Version: $(fjelly --version 2>/dev/null || echo 'N/A')"
else
    echo -e "${RED}✗ fjelly binary not found in PATH${NC}"
fi

# Check 4: mise lists fjelly
if mise list | grep -q "fjelly"; then
    echo -e "${GREEN}✓ fjelly is managed by mise${NC}"
else
    echo -e "${RED}✗ fjelly not found in mise list${NC}"
fi

# Check 5: Old config removed
if [ ! -L "$HOME/.config/fjellyspaces" ]; then
    echo -e "${GREEN}✓ ~/.config/fjellyspaces symlink removed${NC}"
else
    echo -e "${YELLOW}⚠ ~/.config/fjellyspaces symlink still exists${NC}"
fi

echo ""

# Step 5: Show summary
echo -e "${GREEN}✅ Migration complete!${NC}"
echo ""
echo "Summary:"
echo "  • Changes committed to git"
echo "  • fjellyspaces unstowed"
echo "  • fjelly stowed to ~/.config/fjelly"
echo "  • fjelly installed via mise"
echo ""
echo "Next steps (optional):"
echo "  1. Test fjelly: fjelly --help"
echo "  2. Remove old directories (after confirming everything works):"
echo "     rm -rf ~/code/personal/dotfiles/fjellyspaces"
echo "     rm -rf ~/code/personal/dotfiles/fjellyharness"
echo "     mv ~/.local/share/fjellyspaces ~/.local/share/fjellyspaces.backup.$(date +%Y%m%d)"
echo ""
echo "  3. Commit the cleanup:"
echo "     cd ~/code/personal/dotfiles"
echo "     git add -A"
echo "     git commit -m 'chore: remove old fjellyspaces and fjellyharness directories'"
