# fjelly Migration Guide

This guide explains the migration from `fjellyspaces` to `fjelly` in your dotfiles.

## Overview

- **Old tool**: `fjellyspaces` (v0.3.5) - Docker-based workspaces
- **New tool**: `fjelly` (latest) - AI-powered multi-repository task orchestration
- **Config location**: `~/.config/fjelly/`
- **Data location**: `~/.local/share/fjelly/`

## Quick Migration

We've prepared scripts to automate the migration:

### Option 1: Automated Migration (Recommended)

Run the migration script that does everything:

```bash
cd ~/code/personal/dotfiles
chmod +x migrate-to-fjelly.sh
./migrate-to-fjelly.sh
```

This script will:
1. ✅ Commit all changes to git
2. ✅ Unstow `fjellyspaces` and stow `fjelly`
3. ✅ Install `fjelly` via mise
4. ✅ Verify the installation

### Option 2: Manual Steps

If you prefer to run each step manually:

#### Step 1: Commit Changes

```bash
cd ~/code/personal/dotfiles
git add mise/.config/mise/config.toml install fjelly/
git commit -m "feat: migrate from fjellyspaces to fjelly"
```

#### Step 2: Run Stow Commands

```bash
cd ~/code/personal/dotfiles
stow --delete fjellyspaces  # Remove old symlinks
stow --target=$HOME fjelly   # Create new symlinks
```

#### Step 3: Install via Mise

```bash
# Trust and install
mise trust ssh://git@github.com/jordanfjellman/fjelly
mise install ssh://git@github.com/jordanfjellman/fjelly
mise use -g ssh://git@github.com/jordanfjellman/fjelly

# Verify
which fjelly
fjelly --version
```

#### Step 4: Verify Installation

```bash
cd ~/code/personal/dotfiles
chmod +x verify-fjelly.sh
./verify-fjelly.sh
```

## What Changed

### Files Modified

1. **mise/.config/mise/config.toml**
   - Changed: `"github:jordanfjellman/fjellyspaces" = "v0.3.5"`
   - To: `"ssh://git@github.com/jordanfjellman/fjelly" = "latest"`

2. **install**
   - Changed: `STOW_FOLDERS="...,fjellyharness,..."`
   - To: `STOW_FOLDERS="...,fjelly,..."`

3. **fjelly/.config/fjelly/config.toml** (NEW)
   - Created with updated paths
   - Changed all `fjellyspaces` references to `fjelly`
   - Paths updated:
     - `~/.local/share/fjellyspaces/` → `~/.local/share/fjelly/`
     - `fjellyspaces:latest` → `fjelly:latest`

### Directories Structure

```
~/.config/
├── fjelly/                    # NEW (symlinked to dotfiles)
│   └── config.toml            # New config with updated paths
│
└── fjellyspaces/              # OLD (will be removed)
    └── config.toml            # Old config

~/code/personal/dotfiles/
├── fjelly/                    # NEW
│   └── .config/fjelly/
│       └── config.toml
│
├── fjellyspaces/              # OLD (safe to delete after migration)
│   └── .config/fjellyspaces/
│       └── config.toml
│
└── fjellyharness/             # OLD (safe to delete)
    └── .config/fjellyharness/
        └── config.toml
```

## Verification

After migration, verify everything works:

```bash
# Run verification script
./verify-fjelly.sh

# Or manually check:
ls -la ~/.config/fjelly           # Should be a symlink
fjelly --version                  # Should show version
mise list | grep fjelly           # Should show fjelly
```

## Cleanup (After Confirming Everything Works)

Once you've confirmed fjelly works correctly:

```bash
cd ~/code/personal/dotfiles

# Remove old directories from dotfiles
rm -rf fjellyspaces/ fjellyharness/

# Backup and remove old data
mv ~/.local/share/fjellyspaces ~/.local/share/fjellyspaces.backup.$(date +%Y%m%d)
# After a few days, if all is well:
# rm -rf ~/.local/share/fjellyspaces.backup.XXXX

# Commit the cleanup
git add -A
git commit -m "chore: remove old fjellyspaces and fjellyharness directories"
```

## Troubleshooting

### Issue: "fjelly not found" after installation

```bash
# Reload shell or open new terminal
exec fish  # or exec zsh

# Verify mise is loaded
which mise
mise doctor

# Try reinstalling
mise uninstall github:jordanfjellman/fjelly
mise install github:jordanfjellman/fjelly
```

### Issue: Config not found

```bash
# Check if symlink exists
ls -la ~/.config/fjelly

# If not, restow
cd ~/code/personal/dotfiles
stow --target=$HOME fjelly
```

### Issue: Old fjellyspaces still running

```bash
# Stop the old daemon
fj daemon stop  # if using old command

# Or kill manually
pkill -f fjellyspaces
```

## Rollback

If you need to rollback to fjellyspaces:

```bash
# Unstow fjelly
cd ~/code/personal/dotfiles
stow --delete fjelly

# Stow fjellyspaces back
stow --target=$HOME fjellyspaces

# Reinstall via mise
mise uninstall ssh://git@github.com/jordanfjellman/fjelly
mise install github:jordanfjellman/fjellyspaces
mise use -g github:jordanfjellman/fjellyspaces
```

## Additional Resources

- **fjelly repo**: https://github.com/jordan/fjelly
- **fjelly README**: Run `fjelly --help` after installation
- **Dotfiles repo**: ~/code/personal/dotfiles

---

**Status**: Ready for migration ✅
