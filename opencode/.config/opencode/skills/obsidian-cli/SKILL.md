---
name: obsidian-cli
description: Interact with Obsidian vaults from the terminal using the Obsidian CLI. Use this skill when creating, reading, searching, or managing notes, tasks, properties, templates, and QuickAdd choices via the command line.
license: MIT
compatibility: opencode
metadata:
  vault_name: notes
  vault_path: /Users/jordan.fjellman/code/personal/notes
---

## Basics

```
obsidian <command> [key=value ...]
```

- `file=<name>` resolves by name (like wikilinks). `path=<path>` is an exact path.
- Most commands default to the active file when `file`/`path` is omitted.
- Quote values with spaces: `name="My Note"`
- Use `\n` for newline, `\t` for tab in content values.
- Use `vault=notes` to target the vault explicitly (usually unnecessary with a single vault).
- Run `obsidian help <command>` for full details on any command.

## Read & Search

```bash
# Read a note by name
obsidian read file="My Note"

# Read by exact path
obsidian read path="Projects/my-project.md"

# Search vault for text
obsidian search query="some phrase"

# Search with line context
obsidian search:context query="some phrase" format=json

# Limit results and search within a folder
obsidian search query="meeting" path="Ad-Hoc Meetings" limit=5
```

## Create & Write

```bash
# Create a new note
obsidian create name="New Note" content="Initial content here"

# Create in a specific folder
obsidian create path="Projects/new-project.md" content="# New Project"

# Create from a template
obsidian create name="New Note" template="My Template"

# Append content to a note
obsidian append file="Daily Log" content="\n- New item"

# Prepend content to a note
obsidian prepend file="Inbox" content="- Top priority item"

# Append inline (no newline)
obsidian append file="My Note" content=" continued text" inline
```

## File Management

```bash
# List files in vault
obsidian files

# List files in a folder
obsidian files folder="Projects"

# Count files
obsidian files total

# Move a file
obsidian move file="Old Name" to="Archive/Old Name.md"

# Rename a file
obsidian rename file="Draft" name="Final Version"

# Delete a file (to trash)
obsidian delete file="Scratch"

# Delete permanently
obsidian delete file="Scratch" permanent

# List folders
obsidian folders
```

## Properties (Frontmatter)

```bash
# List all properties in vault
obsidian properties

# List properties for a specific file
obsidian properties file="My Note"

# Read a property value
obsidian property:read name="status" file="My Note"

# Set a property
obsidian property:set name="status" value="in-progress" file="My Note"

# Set with explicit type
obsidian property:set name="priority" value="3" type=number file="My Note"

# Remove a property
obsidian property:remove name="draft" file="My Note"

# Get property counts sorted by frequency
obsidian properties sort=count counts
```

## Links & Graph

```bash
# List outgoing links from a file
obsidian links file="My Note"

# List backlinks to a file
obsidian backlinks file="My Note"

# Backlinks with counts in JSON
obsidian backlinks file="My Note" counts format=json

# Find orphan notes (no incoming links)
obsidian orphans

# Find dead-end notes (no outgoing links)
obsidian deadends

# Find unresolved (broken) links
obsidian unresolved
```

## Tasks

```bash
# List all incomplete tasks
obsidian tasks todo

# List completed tasks
obsidian tasks done

# List tasks from daily note
obsidian tasks daily

# List tasks in a specific file
obsidian tasks file="My Project"

# List tasks with file and line info
obsidian tasks todo verbose

# Count tasks
obsidian tasks total

# Toggle a task
obsidian task file="My Note" line=15 toggle

# Mark a task done
obsidian task file="My Note" line=15 done

# Mark a task as todo
obsidian task file="My Note" line=15 todo

# Set a custom status character
obsidian task file="My Note" line=15 status="/"
```

## Tags

```bash
# List all tags
obsidian tags

# List tags with counts, sorted by frequency
obsidian tags counts sort=count

# Get info on a specific tag
obsidian tag name="project"

# Tags for a specific file
obsidian tags file="My Note"
```

## Templates

```bash
# List available templates
obsidian templates

# Read a template's content
obsidian template:read name="Daily Note"

# Read with variables resolved
obsidian template:read name="Daily Note" resolve title="Today's Note"

# Insert a template into the active file
obsidian template:insert name="Meeting Notes"
```

## Vault Info

```bash
# Show vault info
obsidian vault

# Get specific vault info
obsidian vault info=path
obsidian vault info=size

# Show heading outline for a file
obsidian outline file="My Note"
obsidian outline file="My Note" format=json

# Word count
obsidian wordcount file="My Note"
```

## Bases

```bash
# List all base files
obsidian bases

# List views in a base
obsidian base:views file="My Base"

# Query a base view
obsidian base:query file="My Base" view="All Items" format=json

# Create a new item in a base
obsidian base:create file="My Base" name="New Item" content="Some content"
```

## Bookmarks

```bash
# List bookmarks
obsidian bookmarks

# Bookmark a file
obsidian bookmark file="Important Note"

# Bookmark a search query
obsidian bookmark search="todo" title="My Todos"

# Bookmark a URL
obsidian bookmark url="https://example.com" title="Reference"
```

## Sync & History

```bash
# Check sync status
obsidian sync:status

# Pause/resume sync
obsidian sync off
obsidian sync on

# List file history versions
obsidian history file="My Note"

# Read a specific history version
obsidian history:read file="My Note" version=2

# Diff between versions
obsidian diff file="My Note" from=1 to=3
```

## Plugins

```bash
# List community plugins
obsidian plugins filter=community

# List enabled plugins with versions
obsidian plugins:enabled versions

# Enable/disable a plugin
obsidian plugin:enable id=dataview
obsidian plugin:disable id=dataview

# Install a community plugin
obsidian plugin:install id=some-plugin enable
```

## QuickAdd Integration

QuickAdd choices are executed via `obsidian command` using their GUID. Use the table below to translate choice names to command IDs. Never ask the user for a GUID — always look it up here.

```bash
obsidian command id="quickadd:choice:<guid>"
```

| Name | GUID | Type |
|---|---|---|
| Add Task | `0c34ddfc-1841-4c0a-a072-59fb9bae2024` | Template |
| Add Person | `6c500d48-838e-4228-bda9-8425436843a2` | Template |
| Add Lifeway Coworker | `f11aa320-c1b1-433c-83cf-1302d75742c6` | Template |
| Add Lifeway Team | `f55ae6c5-363c-44d1-bbc6-0354d9bd4f30` | Template |
| Add Vendor | `7ef077d9-0e09-4246-bdac-79648a077552` | Template |
| Add Ad-Hoc Meeting | `2098e976-7263-4845-b6f7-58778773a10c` | Template |
| Add Recurring Meeting | `a225acad-87cf-42f4-a8d2-d6fd57d5f15e` | Template |
| Add Work Project | `6ad4a018-47c4-4854-97f3-931632bbcdde` | Template |
| Add Home Project | `69c90184-dffc-4212-aff8-03cb8e316298` | Template |
| Add Permanent Note | `ea732bd6-ef10-499b-97d5-602a77ee152a` | Template |
| Add Strategy | `8661864a-8e87-49e9-b2f8-c8d3fdf8d399` | Template |
| Add Decision | `c6e6a8af-e036-4d96-ab97-5d7c9c5d93ef` | Template |
| Add Application | `f03ef5a2-7b19-4ed2-8704-0243569653a1` | Template |
| Add Service | `bde74fe5-33e9-4fa5-ac95-29f998334a21` | Template |
| Add Blog Post | `fceb41b8-bd0c-4c1a-8e3d-ded4bd7e6335` | Template |
| Add Issue Discovery Note | `9c599c7e-d649-4059-a1c2-b0e84a7ba362` | Template |
| Add Book Literature Note | `5f6a0634-e325-4751-bb8d-8aa259f895d1` | Template |
| Add Podcast Literature Note | `75292889-af3c-4405-817b-91b484d791d6` | Template |
| Add Article Literature Note | `279f4a5f-a3cf-400e-b9c3-030a8063f7ad` | Template |
| Add Conference Session | `b49020a5-a0f2-47fd-8721-0cdd51552905` | Template |
| Add Community Group Lesson | `c0d5262c-b478-4b33-ad1d-addff4f969cb` | Template |
| Add Awana Lesson | `b8865468-cf6f-4ae7-ae0f-85df4655fcb5` | Template |
| Add Narrative | `6a1a9626-bc19-4b0b-828a-0d8273b4ca7a` | Template |
| Add Narrative Review | `f140deb3-cf40-481e-a70b-129b6dccdfd8` | Template |
| Capture Daily Log | `cc5942e1-5c74-4405-b402-d516fcfbe7ca` | Capture |
| Convert to Directory Macro | `f66da051-e759-478b-8d6d-ea0826e8ceaf` | Macro |

Example:

```bash
# Run "Add Task" by name
obsidian command id="quickadd:choice:0c34ddfc-1841-4c0a-a072-59fb9bae2024"

# Run "Capture Daily Log"
obsidian command id="quickadd:choice:cc5942e1-5c74-4405-b402-d516fcfbe7ca"
```

## Output Formats

Many commands support `format=json|tsv|csv` and a `total` flag:

- `format=json` — use when parsing output programmatically
- `format=tsv` — default for most commands, good for piping
- `format=csv` — spreadsheet-friendly
- `total` — returns only a count, useful for checking size before fetching full lists

## Agent Tips

- Prefer `path=` when you have an exact file path. Use `file=` when you have a note name (wikilink-style resolution).
- Use `format=json` when you need to parse command output.
- Use `total` to check counts before fetching large lists.
- For QuickAdd: always use the name-to-GUID table above. Never ask the user for a GUID.
- Dataview queries live inside note content (code blocks), not as CLI commands. Use `read` to inspect them, `append`/`prepend` to add them.
- Templater templates are triggered via `template:insert` or through QuickAdd choices that reference them.
- The Obsidian app must be running for CLI commands to work.
