---
description: Create context-aware AGENTS.md for tasks
agent: build
---

Initialize a task by creating a tailored AGENTS.md file with optional subtask breakdown.

## Process

### 1. Check for Existing File

If AGENTS.md exists, ask user: overwrite, append, or cancel?

### 2. Detect Parent Task File

- Look for markdown files in current working directory
- If found, read frontmatter for default description
- Ask user if they want to use, modify, or start from scratch

### 3. Gather Task Info

Use mcp_question to ask (one question at a time, wait for response):

**a) Task type:**

- Work (Lifeway) - Professional tasks, may have Jira tickets
- Personal project - Side projects and personal work
- Learning - Experimentation and learning new concepts

**b) Activity:**

- Coding - Planning, architecting, and designing code projects
- Writing - Documents, blog posts, narratives, sermons

**c) If Writing, ask document type based on task type:**

_Work documents:_

- ADR
- Product Strategy
- Narrative
- Other

_Personal documents:_

- Blog Post
- Sermon
- Other

**d) Task description:**

- If frontmatter exists, show it and ask: use this, modify, or start fresh?
- Otherwise, ask for description
- The alias can be derived from the description

**e) If Work task (any activity):**

- Related Jira tickets (comma-separated like "PROJ-123, PROJ-456" or "none")
  - Fetch details with `jira_get_issue` for each ticket
  - On fetch failure, note ticket with status "Failed to fetch"

**f) Subtasks:**

- Ask: "Do you want to break this into subtasks? (Enter comma-separated list or 'none')"
- If provided:
  - Create markdown file for each: `{parent_name}_{number}_{subtask_name}.md`
  - Use snake_case for all file names
  - Each gets minimal frontmatter: `aliases: [subtask name as action]`, `description: [subtask name with descriptors]`, and `tags: [subtask]`
  - Update parent task file with `## Subtasks` section containing Obsidian links as a checklist item

**g) Always ask:**

- Any additional reference context files

### 4. Confirm & Create

Show summary and ask for confirmation before creating files.

### 5. Generate AGENTS.md

**Shared Base Template:**

```markdown
# [TASK NAME]

## Task Description

[User description]

## Subtasks

[If subtasks exist, list as Obsidian links:]

- [[parent_task_1_subtask_name]]
- [[parent_task_2_subtask_name]]

## Reference Context

[Context files determined by task type + activity combination]
```

**Context Loading Matrix:**

| Task Type | Activity | Context Files |
| --- | --- | --- |
| Work | Coding | `coding/AGENTS.md`, `lifeway/AGENTS.md` |
| Work | Writing (ADR) | `writing/AGENTS.md`, `writing/engineering/AGENTS.md`, `lifeway/AGENTS.md` + `writing/engineering/adrs.md` |
| Work | Writing (Product Strategy) | `writing/AGENTS.md`, `writing/engineering/AGENTS.md`, `lifeway/AGENTS.md` + `writing/engineering/product_engineering_strategies.md` |
| Work | Writing (Narrative) | `writing/AGENTS.md`, `writing/engineering/AGENTS.md`, `lifeway/AGENTS.md` + `writing/engineering/narratives.md` |
| Work | Writing (Other) | `writing/AGENTS.md`, `writing/engineering/AGENTS.md`, `lifeway/AGENTS.md` |
| Personal | Coding | `coding/AGENTS.md` |
| Personal | Writing (Blog Post) | `writing/AGENTS.md`, `writing/blog/AGENTS.md` |
| Personal | Writing (Sermon) | `writing/AGENTS.md` |
| Personal | Writing (Other) | `writing/AGENTS.md` |
| Learning | Coding | `coding/AGENTS.md`, `learning/AGENTS.md` |

All context file paths are relative to `@~/code/personal/notes/LLM Context/`.

**AI Collaboration Notes — Coding Activity:**

```markdown
## AI Collaboration Notes

**Core Principle: Plan first, build second.**

AI should:

- Break down complex tasks into manageable steps
- Challenge technical assumptions and suggest alternatives
- Identify potential issues and edge cases early
- Help maintain personal philosophy alignment
- Use TodoWrite tool to track progress on multi-step tasks

AI should NOT:

- Make architectural decisions without discussion
- Write without understanding requirements fully
- Ignore the personal philosophy in referenced context
```

**AI Collaboration Notes — Writing Activity:**

```markdown
## AI Collaboration Notes

**Core Principle: You write, AI assists.**

AI should:

- Structure thinking and improve clarity
- Challenge assumptions actively
- Identify reasoning gaps
- Suggest alternative perspectives
- Co-create outlines before writing

AI should NOT:

- Write complete documents for you
- Make decisions on your behalf
- Override your judgment
```

**Work Task Additions (any activity):**

- Related Work Items section with Jira table (if tickets provided)

**Writing + Work (Strategy docs) Additions:**

- AI should: Generate visual diagrams (Mermaid) during refinement

**Writing + Personal (Blog Post) Additions:**

- Topic section
- Writing Reminders section (linking, citations, purpose)

**Learning Task Additions (any activity):**

- Learning Goals section placeholder

### 6. Update Parent Task File (if subtasks created)

Add `## Subtasks` section after frontmatter with Obsidian links to each subtask file:

```markdown
## Subtasks

- [[parent_task_1_subtask_name]]
- [[parent_task_2_subtask_name]]
```

### 7. Confirm Creation

Tell user:

- AGENTS.md created
- Task type: [type]
- Activity: [activity]
- Document type: [type] (if writing)
- Context files loaded: [count]
- Subtask files created: [count or "none"]
- Jira tickets: [count or "none"] (if work task)
- Ready to start

## File Naming Convention

**Subtask files:** `{parent_task_name}_{number}_{subtask_name}.md`

Examples:

- Parent: `setup_authentication.md`
- Subtask 1: "Create JWT handler" → `setup_authentication_1_create_jwt_handler.md`
- Subtask 2: "Add refresh token logic" → `setup_authentication_2_add_refresh_token_logic.md`

**Rules:**

- Use snake_case for all parts
- Number subtasks sequentially starting at 1
- Keep subtask names descriptive but concise
- All files created in same directory as parent task
- Alias the subtasks with `alias` frontmatter and use the alias in the parent task
