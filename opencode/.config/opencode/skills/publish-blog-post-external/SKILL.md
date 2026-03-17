---
name: publish-blog-post-external
description: >
  Prepare and publish a blog post to jordanfjellman.com (Zola static site)
  via pull request. Use this skill when the /publish-blog-post command selects
  "External". Handles link rewriting, SVG export and theming, Zola page bundle
  creation, and PR creation.
---

## Prerequisites

- The canonical vault copy must already exist (created by the publish-blog-post command)
- The Obsidian app must be running (for Excalidraw image export)
- The blog repo is at `~/code/personal/jordanfjellman.com/`
- `gh` CLI must be authenticated for PR creation

## Step 1: Read the Canonical Copy

Read the blog post from the canonical vault location
(`Blog Posts/YYYY-MM-DD Title/Title.md`). Parse the frontmatter and body content.

## Step 2: Create the Zola Page Bundle

1. Derive the slug from the post title (kebab-case, lowercase)
2. Create the page bundle directory: `content/notes/{slug}/`
3. Create the images subdirectory: `content/notes/{slug}/images/`

Work in a new git branch in the blog repo:

```bash
git checkout -b post/{slug}
```

## Step 3: Handle Code Blocks

Scan the post for fenced code blocks. If any meaningful code snippets exist:

1. Check if a gist already exists (from internal publishing) via the vault
   frontmatter `relavent_code_url`
2. If no gist exists, create one:
   ```bash
   gh gist create --public --desc "[Post title] - code examples" <file(s)>
   ```
3. Note the gist URL for the Zola frontmatter `extra.relevant_code_url`

## Step 4: Rewrite Links

Transform links in the post body:

| Source Pattern | Target |
|---|---|
| `[[wikilink to another blog post]]` | `/notes/{target-slug}/` relative link |
| `[[wikilink to non-blog vault note]]` | Remove link, keep text (flag for user) |
| `jordanfjellman.com/notes/{slug}` | Keep as-is (already correct) |
| Confluence links | Remove link, keep text (flag for user) unless a public equivalent exists |
| `[text](https://external-site.com/...)` | Leave untouched |

If a link cannot be resolved, flag it for the user and leave the text without
a link.

## Step 5: Handle Excalidraw Images

1. Identify all `.excalidraw.md` files referenced in the post (look for
   `![[filename]]` or `![[filename.excalidraw]]` embeds)
2. For each image, ask the user to export it:
   - "Please export `[filename]` as SVG from Obsidian (Copy to clipboard as SVG),
     then save it to `content/notes/{slug}/images/[filename].svg`"
3. Wait for the user to confirm each export before proceeding
4. Run the themeify script on each SVG:
   ```bash
   node scripts/themeify.js content/notes/{slug}/images/[filename].svg
   ```
5. Copy the source `.excalidraw.md` files into the page bundle directory
   (alongside `index.md`) for future re-generation
6. Replace Obsidian embed syntax with the Zola SVG shortcode:
   ```
   {{ svg(src="images/[filename].svg") }}
   ```

## Step 6: Generate Zola Frontmatter

Map vault frontmatter to Zola frontmatter:

```yaml
---
title: [vault title]
date: [vault published_date, or today's date in YYYY-MM-DD]
description: >
  [vault description]
tags:
  - [each vault tag]
extra:
  relevant_code_url: |
    [gist URL if available]
---
```

Only include `extra.relevant_code_url` if a gist exists.

## Step 7: Transform Post Body

1. Remove Obsidian-specific syntax:
   - `![[embeds]]` → replaced with SVG shortcodes in Step 5
   - Dataview queries → remove
   - Obsidian callouts `> [!try] Try it` → convert to a blockquote with bold
     prefix: `> **Try it:** ...`

2. Remove the `# Title` H1 heading (Zola renders the title from frontmatter)

3. Keep the `## If you only read this far` section if present

4. Ensure all image references use the `{{ svg(src="images/...") }}` shortcode

## Step 8: Write index.md

Write the complete transformed post (frontmatter + body) to
`content/notes/{slug}/index.md`.

## Step 9: Run Prepare Script (if implemented)

If `scripts/prepare-external.js` exists and is not a placeholder, run it:

```bash
node scripts/prepare-external.js content/notes/{slug}/
```

## Step 10: Open a Pull Request

Stage, commit, and push the new page bundle:

```bash
git add content/notes/{slug}/
git commit -m "Add post: [title]"
git push -u origin post/{slug}
```

Open a PR:

```bash
gh pr create --title "New post: [title]" --body "Adds blog post: [title]"
```

## Step 11: Return Results

Report back to the publish-blog-post command with:
- PR URL
- Gist URL if created (for setting `relavent_code_url` in vault frontmatter)
- Any links that could not be resolved
- Any images that still need manual export

## Glossary Terms

Do NOT automatically ask about adding glossary terms. Only when the user
specifically requests it, add a term to `static/data/glossary.toml`:

```toml
[[terms]]
title = "Term Name"
slug = "term-name"
description = "What this term means."
credit_name = "Optional attribution"
credit_url = "https://optional-source-url"
```

Commit the glossary update in the same PR branch.
