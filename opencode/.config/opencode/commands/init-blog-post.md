---
description: Initialize a blog post task with AGENTS.md
agent: build
---

Initialize a personal blog post writing task. Pre-fills `activity=writing`,
`doc_type=blog_post`, and `task_type=personal`, skipping three questions.

## Process

### 1. Load the init-task skill

Load the `init-task` skill for shared generation logic.

### 2. Gather Parameters

Pre-filled:
- `activity` = writing
- `doc_type` = blog_post
- `task_type` = personal

Use mcp_question to ask (one question at a time, wait for response):

**a) Task description:**

- Check for markdown files in current working directory
- If found, read frontmatter and ask: use this, modify, or start fresh?
- Otherwise, ask for description

**b) Subtasks:**

- Ask: "Do you want to break this into subtasks? (Enter comma-separated list or 'none')"

**c) Always ask:**

- Any additional reference context files

### 3. Confirm & Generate

Show summary and ask for confirmation. Then follow the init-task skill steps
(3 through 7) to generate AGENTS.md, create subtask files, and confirm.
