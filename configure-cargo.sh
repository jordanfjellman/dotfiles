#!/bin/bash
# Configure cargo to use git CLI for private repos

mkdir -p ~/.cargo

cat > ~/.cargo/config.toml << 'EOF'
[net]
git-fetch-with-cli = true
EOF

echo "✓ Cargo configured to use git CLI"
