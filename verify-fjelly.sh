#!/bin/bash
# Verification script for fjelly installation
# Run this to check if the migration was successful

echo "🔍 Verifying fjelly installation..."
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

errors=0
warnings=0

# Check 1: fjelly binary in PATH
echo "Check 1: fjelly binary"
if command -v fjelly &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} fjelly is in PATH"
    echo "    Version: $(fjelly --version 2>/dev/null || echo 'N/A')"
    echo "    Location: $(which fjelly)"
else
    echo -e "  ${RED}✗${NC} fjelly not found in PATH"
    ((errors++))
fi
echo ""

# Check 2: Config directory symlinked
echo "Check 2: Config directory"
if [ -L "$HOME/.config/fjelly" ]; then
    echo -e "  ${GREEN}✓${NC} ~/.config/fjelly is symlinked"
    echo "    Points to: $(readlink $HOME/.config/fjelly)"
else
    echo -e "  ${RED}✗${NC} ~/.config/fjelly is not symlinked"
    ((errors++))
fi
echo ""

# Check 3: Config file exists
echo "Check 3: Config file"
if [ -f "$HOME/.config/fjelly/config.toml" ]; then
    echo -e "  ${GREEN}✓${NC} ~/.config/fjelly/config.toml exists"
    # Verify it's the new config
    if grep -q "fjelly:latest" "$HOME/.config/fjelly/config.toml" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} Config contains correct paths"
    else
        echo -e "  ${YELLOW}⚠${NC} Config may be the old version"
        ((warnings++))
    fi
else
    echo -e "  ${RED}✗${NC} ~/.config/fjelly/config.toml not found"
    ((errors++))
fi
echo ""

# Check 4: Mise integration
echo "Check 4: Mise status"
if command -v mise &> /dev/null; then
    if mise list | grep -q "fjelly"; then
        echo -e "  ${GREEN}✓${NC} fjelly is managed by mise"
        mise list | grep "fjelly" | head -1
    else
        echo -e "  ${YELLOW}⚠${NC} fjelly not found in mise list"
        ((warnings++))
    fi
else
    echo -e "  ${YELLOW}⚠${NC} mise not installed"
fi
echo ""

# Check 5: Old config removed
echo "Check 5: Old configurations"
if [ -L "$HOME/.config/fjellyspaces" ]; then
    echo -e "  ${YELLOW}⚠${NC} ~/.config/fjellyspaces symlink still exists"
    ((warnings++))
else
    echo -e "  ${GREEN}✓${NC} ~/.config/fjellyspaces removed"
fi

if [ -L "$HOME/.config/fjellyharness" ]; then
    echo -e "  ${YELLOW}⚠${NC} ~/.config/fjellyharness symlink still exists"
    ((warnings++))
else
    echo -e "  ${GREEN}✓${NC} ~/.config/fjellyharness removed"
fi
echo ""

# Summary
echo "================================"
if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed!${NC}"
    echo "fjelly is properly installed and configured."
    exit 0
elif [ $errors -eq 0 ]; then
    echo -e "${YELLOW}⚠️  $warnings warning(s)${NC}"
    echo "fjelly is installed but there are some warnings."
    exit 0
else
    echo -e "${RED}❌ $errors error(s), $warnings warning(s)${NC}"
    echo "Please fix the errors above."
    exit 1
fi
