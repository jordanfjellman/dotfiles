---
description: Publish a blog post to Confluence (internal) or jordanfjellman.com (external)
agent: build
---

Prepare and publish a blog post from the current working directory. Creates a
canonical copy in the Obsidian vault, then transforms it for the target
destination.

## Process

### 1. Identify the Draft

- Look for the blog post markdown file in the current working directory
- Read its frontmatter and content
- Confirm with the user: "Publish from [filename]?"

### 2. Ask: Internal or External?

- Internal — Publish as a draft to Confluence Engineering Hub
- External — Open a PR to the jordanfjellman.com blog repo

### 3. Create Canonical Vault Copy

Run the QuickAdd "Add Blog Post" command to create the final Obsidian note:

```bash
obsidian command id="quickadd:choice:fceb41b8-bd0c-4c1a-8e3d-ded4bd7e6335"
```

This creates a note at `Blog Posts/YYYY-MM-DD Title/Title.md` with the blog
post template frontmatter. Copy the draft content into this new note, preserving
the template frontmatter fields and merging any values from the draft.

Also copy any `.excalidraw.md` files from the task directory into the new blog
post directory so they live alongside the canonical copy.

### 4. Delegate to Publish Skill

- If Internal: load the `publish-blog-post-internal` skill
- If External: load the `publish-blog-post-external` skill

The skill operates on the canonical vault copy created in step 3.

### 5. Update Vault Frontmatter

After publishing:
- Internal: set `confluence_url` in the vault note's frontmatter
- External: set `publish: true` and `published_date` in the vault note's frontmatter
- If a GitHub Gist was created for code blocks: set `relavent_code_url`
