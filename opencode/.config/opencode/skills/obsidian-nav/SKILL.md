---
name: obsidian-nav
description: Resolve and follow Obsidian [[wikilinks]] to real file paths using the vault on disk. Use this skill whenever you encounter [[wikilink]] syntax or need to navigate between notes in an Obsidian vault.
license: MIT
compatibility: opencode
metadata:
  vault_path: /Users/you/Documents/MyVault
  exclude_dirs: .obsidian,.trash,templates,scripts
  daily_notes_dir: daily
---

## Locate the vault root

Walk up from `$PWD` to find the directory containing `.obsidian/`:

```bash
root="$PWD"
while [[ "$root" != "/" ]]; do
  [[ -d "$root/.obsidian" ]] && echo "$root" && break
  root=$(dirname "$root")
done
```

## Build a note index (do this once)

Run a single `fd` pass from the vault root to map note names to paths.
Use this index for all subsequent link resolution — do not run a new search per link.

```bash
fd --type f --extension md \
  --exclude .obsidian --exclude .trash --exclude templates --exclude scripts \
  <vault-root>
```

The index is: basename (without `.md`) → full path.

Note: `daily/` is intentionally **not** excluded from the index — daily notes may contain wikilinks worth following. Skip them only if the task is clearly unrelated to journal content.

## Resolve a [[wikilink]]

Wikilinks take these forms — always extract the bare note name first:

| Syntax                         | Extract                       |
| ------------------------------ | ----------------------------- |
| `[[Note Name]]`                | `Note Name`                   |
| `[[Note Name\|Alias]]`         | `Note Name` (drop after `\|`) |
| `[[Note Name#Heading]]`        | `Note Name` (drop after `#`)  |
| `[[Note Name#Heading\|Alias]]` | `Note Name` (drop after both) |

Look up the extracted name in the index. Do not call `fd` again per link.

## Extract all wikilinks from one or more files (batch)

```bash
rg --no-heading -o '\[\[([^\]|#]+)' <file1.md> [file2.md ...] | sed 's/.*\[\[//'
```

## Follow links recursively

1. Read the starting note, batch-extract its wikilinks
2. Resolve all links against the index
3. Queue unvisited resolved paths
4. Read all queued notes, then batch-extract wikilinks in a **single `rg` call** across all files
5. Resolve new links, queue unvisited paths
6. Repeat until the queue is empty
7. **Never visit the same path twice** — maintain a visited set to prevent loops
