---
description: Fetch Confluence page comments and format as actionable Obsidian callouts
agent: build
---

Fetch comments from a Confluence page and write them as an actionable Obsidian markdown file with callouts.

## Arguments

- `$1` — Confluence page ID (required, the numeric ID from the page URL)
- `$2` — Path to a local markdown file for cross-referencing (optional)

If `$1` is missing, ask the user for the page ID before proceeding.

## Process

### 1. Fetch Page Metadata

Use `confluence_get_page` with page_id `$1` to get:

- Page title
- Space key
- Build the web URL: `https://lifeway.atlassian.net/wiki/spaces/{SPACE}/pages/{PAGE_ID}/{URL_ENCODED_TITLE}`

If the page ID is invalid or the fetch fails, tell the user and stop. Do not write a file.

### 2. Fetch Comments

Use `confluence_get_comments` with page_id `$1`.

If no comments are found, write a file with a note: "No comments found on this page."

### 3. Read Local File (if provided)

If `$2` is provided:

- Read the file at that path
- Parse all headings (`#`, `##`, `###`, etc.) and their nearby paragraph content
- Build a lookup of heading text → section content for fuzzy matching later

If the file doesn't exist or can't be read, note this but continue without cross-referencing.

### 4. Build Output File

**Filename:** Derive from the page title using snake_case: `comments_{snake_case_title}.md`

Write the file in the current working directory.

**File structure:**

```markdown
---
tags: [review, comments]
source: {confluence_web_url}
fetched: {today's date YYYY-MM-DD}
---

# Comments: {Page Title}

**Source:** [{Page Title}]({confluence_web_url})
**Local copy:** [[{local_filename_without_extension}]]
**Fetched:** {today's date YYYY-MM-DD}

---
```

If no local file was provided, omit the "Local copy" line entirely.

### 5. Format Each Comment

For each top-level comment:

```markdown
- [ ] **{Author Display Name}** — {Comment Date YYYY-MM-DD}

> [!quote]
> {Comment body content, preserving line breaks within the callout}

> [!tip] Context
> {Matched section excerpt from local doc}
> See: [[{local_filename}#{Matched Heading}]]

---
```

**Nesting rules for replies:**

- Top-level comments: `- [ ]` with no indentation
- Replies to comments: `  - [ ]` (2-space indent) under their parent
- Each reply gets its own `[!quote]` callout, indented with 2 spaces
- Replies do NOT get `[!tip] Context` callouts — only top-level comments do
- Top-level comments are separated by `---`

**Cross-reference matching (only when local file was provided):**

- For each top-level comment, fuzzy-match its content against heading text and nearby paragraph content from the local file
- Match strategy: look for keyword overlap between the comment text and section headings/content
- If a reasonable match is found, include the `[!tip] Context` callout with:
  - A brief excerpt (2-3 sentences max) from the matched section
  - An Obsidian link: `[[{local_filename_without_extension}#{Heading Name}]]`
- If no match is found, omit the `[!tip] Context` callout for that comment

### 6. Confirm Completion

Tell the user:

- File created at `{path}`
- Total comments: `{count}` (top-level) + `{count}` (replies)
- Cross-references matched: `{count}` (if local file was provided)
