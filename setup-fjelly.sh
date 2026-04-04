#!/bin/bash
# Setup script for fjelly - builds from source and configures shell integration
# This bypasses the mise authentication issues with private repos

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Setting up fjelly from source...${NC}"
echo ""

FJELLY_DIR="$HOME/code/personal/fjelly"
INSTALL_DIR="$HOME/.local/bin"

# Step 1: Clone or update repository
echo -e "${YELLOW}Step 1: Cloning fjelly repository...${NC}"
if [ -d "$FJELLY_DIR" ]; then
    echo "  → Repository exists, pulling latest changes..."
    cd "$FJELLY_DIR"
    git pull origin main
else
    echo "  → Cloning repository..."
    git clone git@github.com:jordanfjellman/fjelly.git "$FJELLY_DIR"
    cd "$FJELLY_DIR"
fi
echo -e "${GREEN}✓ Repository ready${NC}"
echo ""

# Step 2: Build release binary
echo -e "${YELLOW}Step 2: Building fjelly...${NC}"
cd "$FJELLY_DIR"
echo "  → Running cargo build --release (this may take a few minutes)..."
cargo build --release 2>&1 | tail -5
echo -e "${GREEN}✓ Build complete${NC}"
echo ""

# Step 3: Install binary
echo -e "${YELLOW}Step 3: Installing binary...${NC}"
mkdir -p "$INSTALL_DIR"
cp "$FJELLY_DIR/target/release/fjelly" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/fjelly"
echo -e "${GREEN}✓ Installed to $INSTALL_DIR/fjelly${NC}"
echo ""

# Step 4: Ensure PATH includes ~/.local/bin
echo -e "${YELLOW}Step 4: Updating PATH...${NC}"
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "  → Adding ~/.local/bin to PATH in shell configs..."
    
    # Zsh
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc"; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
            echo "  → Added to .zshrc"
        fi
    fi
    
    # Bash
    if [ -f "$HOME/.bashrc" ]; then
        if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
            echo "  → Added to .bashrc"
        fi
    fi
    
    # Fish
    if [ -d "$HOME/.config/fish" ]; then
        if ! grep -q '$HOME/.local/bin' "$HOME/.config/fish/config.fish" 2>/dev/null; then
            echo 'fish_add_path $HOME/.local/bin' >> "$HOME/.config/fish/config.fish"
            echo "  → Added to fish config.fish"
        fi
    fi
else
    echo "  → ~/.local/bin already in PATH"
fi
echo -e "${GREEN}✓ PATH configured${NC}"
echo ""

# Step 5: Setup completions
echo -e "${YELLOW}Step 5: Setting up shell completions...${NC}"

# Generate completions
echo "  → Generating completions..."
cd "$FJELLY_DIR"

# Fish completions
if [ -d "$HOME/.config/fish/completions" ]; then
    ./target/release/fjelly completions fish > "$HOME/.config/fish/completions/fjelly.fish" 2>/dev/null || true
    if [ -f "$HOME/.config/fish/completions/fjelly.fish" ]; then
        echo "  → Fish completions installed"
    fi
fi

# Zsh completions
if [ -d "$HOME/.config/zsh" ] || [ -d "$HOME/.zsh" ]; then
    mkdir -p "$HOME/.config/zsh/completions" 2>/dev/null || mkdir -p "$HOME/.zsh/completions" 2>/dev/null || true
    ./target/release/fjelly completions zsh > "$HOME/.config/zsh/completions/_fjelly" 2>/dev/null || \
    ./target/release/fjelly completions zsh > "$HOME/.zsh/completions/_fjelly" 2>/dev/null || true
    echo "  → Zsh completions generated (may need manual setup)"
fi

# Bash completions
if [ -d /etc/bash_completion.d ] || [ -d "$HOME/.bash_completion.d" ]; then
    mkdir -p "$HOME/.bash_completion.d" 2>/dev/null || true
    ./target/release/fjelly completions bash > "$HOME/.bash_completion.d/fjelly" 2>/dev/null || true
    if [ -f "$HOME/.bash_completion.d/fjelly" ]; then
        echo "  → Bash completions installed"
    fi
fi

echo -e "${GREEN}✓ Completions configured${NC}"
echo ""

# Step 6: Create update alias/function
echo -e "${YELLOW}Step 6: Setting up update function...${NC}"

# Create update script
mkdir -p "$HOME/.local/bin"
cat > "$HOME/.local/bin/update-fjelly" << 'EOF'
#!/bin/bash
# Update fjelly from source

FJELLY_DIR="$HOME/code/personal/fjelly"
INSTALL_DIR="$HOME/.local/bin"

echo "Updating fjelly..."
cd "$FJELLY_DIR"

echo "→ Pulling latest changes..."
git pull origin main

echo "→ Building..."
cargo build --release

echo "→ Installing..."
cp "$FJELLY_DIR/target/release/fjelly" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/fjelly"

echo "→ Updating completions..."
"$INSTALL_DIR/fjelly" completions fish > "$HOME/.config/fish/completions/fjelly.fish" 2>/dev/null || true

echo "✓ fjelly updated successfully!"
"$INSTALL_DIR/fjelly" --version
EOF

chmod +x "$HOME/.local/bin/update-fjelly"

# Add alias/function for zsh
if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q "alias fjelly-update=" "$HOME/.zshrc"; then
        echo '' >> "$HOME/.zshrc"
        echo '# fjelly update alias' >> "$HOME/.zshrc"
        echo 'alias fjelly-update="$HOME/.local/bin/update-fjelly"' >> "$HOME/.zshrc"
        echo "  → Added zsh alias: fjelly-update"
    fi
fi

# Add function for fish
if [ -d "$HOME/.config/fish" ]; then
    if [ ! -f "$HOME/.config/fish/functions/fjelly-update.fish" ]; then
        cat > "$HOME/.config/fish/functions/fjelly-update.fish" << 'EOF'
function fjelly-update
    $HOME/.local/bin/update-fjelly
end
EOF
        echo "  → Added fish function: fjelly-update"
    fi
fi

echo -e "${GREEN}✓ Update function configured${NC}"
echo ""

# Summary
echo -e "${GREEN}✅ fjelly setup complete!${NC}"
echo ""
echo "Installation summary:"
echo "  • Binary: $INSTALL_DIR/fjelly"
echo "  • Source: $FJELLY_DIR"
echo "  • Config: ~/.config/fjelly/"
echo ""
echo "Commands:"
echo "  fjelly --version          # Check version"
echo "  fjelly --help             # Show help"
echo "  fjelly-update (or alias)  # Update from source"
echo ""
echo "Next steps:"
echo "  1. Reload your shell or run: source ~/.zshrc  # or exec fish"
echo "  2. Verify: fjelly --version"
echo "  3. Run: fjelly init personal"
echo ""
echo "To update in the future:"
echo "  fjelly-update     # Updates from source and rebuilds"
