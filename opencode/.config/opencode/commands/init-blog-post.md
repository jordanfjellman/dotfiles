---
description: Initialize a blog post writing task with AGENTS.md
agent: build
---

Initialize a blog post writing task. Pre-fills `activity=writing` and
`doc_type=blog_post`. Asks whether the post is internal (work) or external
(personal) to load the right context.

## Process

### 1. Load the init-task skill

Load the `init-task` skill for shared generation logic.

### 2. Gather Parameters

Pre-filled:
- `activity` = writing
- `doc_type` = blog_post

Use mcp_question to ask (one question at a time, wait for response):

**a) Internal or External?**

- Internal (work) — Published to Confluence Engineering Hub for the team
- External (personal) — Published to jordanfjellman.com for the public

Maps: Internal → `task_type=work`, External → `task_type=personal`

**b) Task description:**

- Check for markdown files in current working directory
- If found, read frontmatter and ask: use this, modify, or start fresh?
- Otherwise, ask for description

**c) If Internal (work):**

- Related Jira tickets (comma-separated like "PROJ-123, PROJ-456" or "none")

**d) Subtasks:**

- Ask: "Do you want to break this into subtasks? (Enter comma-separated list or 'none')"

**e) Always ask:**

- Any additional reference context files

### 3. Confirm & Generate

Show summary and ask for confirmation. Then follow the init-task skill steps
(3 through 7) to generate AGENTS.md, create subtask files, and confirm.
