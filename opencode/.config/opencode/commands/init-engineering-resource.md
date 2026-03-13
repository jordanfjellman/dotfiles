---
description: Initialize an engineering resource writing task with AGENTS.md
agent: build
---

Initialize a work engineering resource writing task. Pre-fills `activity=writing`,
`doc_type=engineering_resource`, and `task_type=work`, skipping three questions.

## Process

### 1. Load the init-task skill

Load the `init-task` skill for shared generation logic.

### 2. Gather Parameters

Pre-filled:

- `activity` = writing
- `doc_type` = engineering_resource
- `task_type` = work

Use mcp_question to ask (one question at a time, wait for response):

**a) Task description:**

- Check for markdown files in current working directory
- If found, read frontmatter and ask: use this, modify, or start fresh?
- Otherwise, ask for description

**b) Related Jira tickets:**

- Comma-separated like "PROJ-123, PROJ-456" or "none"

**c) Subtasks:**

- Ask: "Do you want to break this into subtasks? (Enter comma-separated list or 'none')"

**d) Confluence URL:**

- Ask: "Do you want to link to a Confluence page for which this narrative is going to be published?"
- If yes, ask for Confluence URL, and store in `additional_context`

**e) Always ask:**

- Any additional reference context files

### 3. Confirm & Generate

Show summary and ask for confirmation. Then follow the init-task skill steps
(3 through 7) to generate AGENTS.md, create subtask files, and confirm.
