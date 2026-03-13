---
description: Create context-aware AGENTS.md for any task type
agent: build
---

Initialize a task by creating a tailored AGENTS.md file. This is the generic
command that asks all questions. For faster setup, use a specialized command:

- `/init-coding` — coding tasks (skips activity question)
- `/init-blog-post` — personal blog posts (skips activity, doc type, task type)
- `/init-narrative` — work narratives (skips activity, doc type, task type)
- `/init-engineering-resource` — work engineering resources (skips activity, doc type, task type)

## Process

### 1. Load the init-task skill

Load the `init-task` skill for shared generation logic.

### 2. Gather All Parameters

Use mcp_question to ask (one question at a time, wait for response):

**a) Task type:**

- Work (Lifeway) — Professional tasks, may have Jira tickets
- Personal project — Side projects and personal work
- Learning — Experimentation and learning new concepts

**b) Activity:**

- Coding — Planning, architecting, and designing code projects
- Writing — Documents, blog posts, narratives, sermons

**c) If Writing, ask document type based on task type:**

_Work documents:_

- ADR
- Product Strategy
- Narrative
- Engineering Resource
- Other

_Personal documents:_

- Blog Post
- Sermon
- Other

**d) Task description:**

- Check for markdown files in current working directory
- If found, read frontmatter and ask: use this, modify, or start fresh?
- Otherwise, ask for description

**e) If Work task (any activity):**

- Related Jira tickets (comma-separated like "PROJ-123, PROJ-456" or "none")

**f) Subtasks:**

- Ask: "Do you want to break this into subtasks? (Enter comma-separated list or 'none')"

**g) Always ask:**

- Any additional reference context files

### 3. Confirm & Generate

Show summary and ask for confirmation. Then follow the init-task skill steps
(3 through 7) to generate AGENTS.md, create subtask files, and confirm.
