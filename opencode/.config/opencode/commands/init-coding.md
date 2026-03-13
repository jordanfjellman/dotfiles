---
description: Initialize a coding task with AGENTS.md
agent: build
---

Initialize a coding task. Pre-fills `activity=coding`, skipping the activity
question.

## Process

### 1. Load the init-task skill

Load the `init-task` skill for shared generation logic.

### 2. Gather Parameters

Pre-filled:
- `activity` = coding

Use mcp_question to ask (one question at a time, wait for response):

**a) Task type:**

- Work (Lifeway) — Professional tasks, may have Jira tickets
- Personal project — Side projects and personal work
- Learning — Experimentation and learning new concepts

**b) Task description:**

- Check for markdown files in current working directory
- If found, read frontmatter and ask: use this, modify, or start fresh?
- Otherwise, ask for description

**c) If Work task:**

- Related Jira tickets (comma-separated like "PROJ-123, PROJ-456" or "none")

**d) Subtasks:**

- Ask: "Do you want to break this into subtasks? (Enter comma-separated list or 'none')"

**e) Always ask:**

- Any additional reference context files

### 3. Confirm & Generate

Show summary and ask for confirmation. Then follow the init-task skill steps
(3 through 7) to generate AGENTS.md, create subtask files, and confirm.
