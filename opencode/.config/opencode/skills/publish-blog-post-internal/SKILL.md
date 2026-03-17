---
name: publish-blog-post-internal
description: >
  Prepare and publish a blog post to Confluence Engineering Hub as a draft.
  Use this skill when the /publish-blog-post command selects "Internal".
  Handles link rewriting, image export, Confluence formatting, code block
  gist creation, and publishing via Atlassian MCP.
---

## Prerequisites

- The canonical vault copy must already exist (created by the publish-blog-post command)
- The Obsidian app must be running (for Excalidraw image export)
- Atlassian MCP server must be available for Confluence operations

## Step 1: Read the Canonical Copy

Read the blog post from the canonical vault location
(`Blog Posts/YYYY-MM-DD Title/Title.md`). Parse the frontmatter and body content.

## Step 2: Handle Code Blocks

Scan the post for fenced code blocks. If any meaningful code snippets exist:

1. Create a GitHub Gist using `gh gist create`:
   ```bash
   gh gist create --public --desc "[Post title] - code examples" <file(s)>
   ```
2. For multiple code blocks, group them into a single multi-file gist
3. Note the gist URL — it will be set in the vault frontmatter later

## Step 3: Rewrite Links

Transform links in the post body:

| Source Pattern | Target |
|---|---|
| `jordanfjellman.com/notes/{slug}` | Search Confluence for matching page title, link to it |
| `[[wikilink]]` | Search Confluence for matching page title via `confluence_search`, link to it |
| `[text](https://external-site.com/...)` | Leave untouched |

If a Confluence page cannot be found for a wikilink or blog link, flag it for
the user and leave the text without a link.

## Step 4: Handle Excalidraw Images

1. Identify all `.excalidraw.md` files referenced in the post (look for
   `![[filename]]` or `![[filename.excalidraw]]` embeds)
2. For each image, ask the user to export it:
   - "Please export `[filename]` as PNG from Obsidian (Copy to clipboard as PNG),
     then save it to `[vault blog post directory]/images/[filename].png`"
3. Wait for the user to confirm each export before proceeding
4. Replace the Obsidian embed syntax with a reference to the PNG attachment

## Step 5: Apply Confluence Formatting

Transform the markdown for Confluence:

1. Add an info panel at the top of the body:
   ```
   > **At a Glance:** [description from frontmatter]
   ```

2. Add a table of contents immediately after the info panel:
   ```
   [TOC]
   ```

3. Convert any `> [!try] Try it` Obsidian callouts to Confluence note panels

4. Ensure code blocks specify a language for Confluence's code macro

5. Remove any Obsidian-specific syntax that doesn't translate to Confluence
   (e.g., `![[embeds]]`, dataview queries)

## Step 6: Publish to Confluence as Draft

Use the Atlassian MCP tools to create the page:

1. Use `confluence_create_page` with:
   - `space_key`: `SEC1` (Engineering Hub)
   - `title`: Post title from frontmatter
   - `content`: The transformed markdown
   - `content_format`: `markdown`

2. The page is created as a **draft** — do NOT share or notify anyone.
   Confluence pages created via API are not published to the space feed
   unless explicitly shared.

3. If the post has PNG images, upload them as attachments using
   `confluence_upload_attachment` for each image file.

## Step 7: Return Results

Report back to the publish-blog-post command with:
- Confluence page URL (for setting `confluence_url` in vault frontmatter)
- Gist URL if created (for setting `relavent_code_url` in vault frontmatter)
- Any links that could not be resolved
- Any images that still need manual export
