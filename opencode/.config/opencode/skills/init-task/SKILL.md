---
name: init-task
description: >
  Shared logic for initializing task AGENTS.md files. Used by init-task,
  init-coding, init-blog-post, init-narrative, and init-engineering-resource
  commands. Do not invoke this skill directly — use one of the commands instead.
---

## Purpose

This skill contains the shared generation logic for all `/init-*` commands. Each
command resolves its own parameters (task type, activity, document type, etc.)
and then delegates here for file generation.

This skill does NOT ask questions. It expects the calling command to provide
resolved parameters.

## Expected Parameters

The calling command must resolve these before invoking this skill:

| Parameter | Required | Values |
|---|---|---|
| `task_type` | yes | `work`, `personal`, `learning` |
| `activity` | yes | `coding`, `writing` |
| `doc_type` | if writing | `adr`, `product_strategy`, `narrative`, `engineering_resource`, `blog_post`, `sermon`, `other` |
| `description` | yes | free text |
| `jira_tickets` | if work | comma-separated keys or "none" |
| `subtasks` | yes | comma-separated list or "none" |
| `additional_context` | no | extra context file paths |

## Step 1: Check for Existing AGENTS.md

If AGENTS.md exists in the current working directory, ask user: overwrite, append, or cancel?

## Step 2: Detect Parent Task File

- Look for markdown files in current working directory
- If found, read frontmatter for default description
- If the calling command already gathered a description, skip this

## Step 3: Resolve Context Files

Use this matrix to determine which context files to load. All paths are relative
to `@~/code/personal/notes/LLM Context/`.

| Task Type | Activity | Doc Type | Context Files |
|---|---|---|---|
| Work | Coding | — | `coding/AGENTS.md`, `lifeway/AGENTS.md` |
| Work | Writing | ADR | `writing/AGENTS.md`, `writing/engineering/AGENTS.md`, `lifeway/AGENTS.md`, `writing/engineering/adrs.md` |
| Work | Writing | Product Strategy | `writing/AGENTS.md`, `writing/engineering/AGENTS.md`, `lifeway/AGENTS.md`, `writing/engineering/product_engineering_strategies.md` |
| Work | Writing | Narrative | `writing/AGENTS.md`, `writing/engineering/AGENTS.md`, `lifeway/AGENTS.md`, `writing/engineering/narratives.md` |
| Work | Writing | Engineering Resource | `writing/AGENTS.md`, `writing/engineering/AGENTS.md`, `lifeway/AGENTS.md`, `writing/engineering/engineering_resource.md` |
| Work | Writing | Other | `writing/AGENTS.md`, `writing/engineering/AGENTS.md`, `lifeway/AGENTS.md` |
| Personal | Coding | — | `coding/AGENTS.md` |
| Personal | Writing | Blog Post | `writing/AGENTS.md`, `writing/blog/AGENTS.md` |
| Personal | Writing | Sermon | `writing/AGENTS.md` |
| Personal | Writing | Other | `writing/AGENTS.md` |
| Learning | Coding | — | `coding/AGENTS.md`, `learning/AGENTS.md` |

Append any `additional_context` files the user provided.

## Step 4: Generate AGENTS.md

### Base Template

```markdown
# [TASK NAME]

## Task Description

[User description]

## Subtasks

[If subtasks exist, list as Obsidian links:]

- [[parent_task_1_subtask_name]]
- [[parent_task_2_subtask_name]]

## Reference Context

[Context files from the matrix above]
```

### AI Collaboration Notes — Coding Activity

Include this section when `activity=coding`:

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

### AI Collaboration Notes — Writing Activity

Include this section when `activity=writing`:

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

### Work Task Additions (any activity)

If `task_type=work` and Jira tickets were provided, add:

```markdown
## Related Work Items

| Ticket | Summary | Status |
|---|---|---|
| [KEY] | [Summary from jira_get_issue] | [Status] |
```

For each ticket, fetch details with `jira_get_issue`. On fetch failure, note the
ticket with status "Failed to fetch".

### Writing + Work (Strategy docs) Additions

If `activity=writing` and `task_type=work` and doc_type is `product_strategy`,
`narrative`, or `adr`:

- AI should: Generate visual diagrams (Mermaid) during refinement

### Writing + Personal (Blog Post) Additions

If `activity=writing` and `doc_type=blog_post`:

- Add Topic section
- Add Writing Reminders section (linking, citations, purpose)

### Learning Task Additions (any activity)

If `task_type=learning`:

- Add Learning Goals section placeholder

## Step 5: Create Subtask Files (if provided)

For each subtask:

1. Create file: `{parent_task_name}_{number}_{subtask_name}.md`
2. Use snake_case for all file names
3. Add frontmatter: `aliases: [subtask name as action]`, `description: [subtask name with descriptors]`, `tags: [subtask]`
4. Create in same directory as parent task

### Naming Rules

- Use snake_case for all parts
- Number subtasks sequentially starting at 1
- Keep subtask names descriptive but concise

Examples:
- Parent: `setup_authentication.md`
- Subtask 1: "Create JWT handler" -> `setup_authentication_1_create_jwt_handler.md`
- Subtask 2: "Add refresh token logic" -> `setup_authentication_2_add_refresh_token_logic.md`

## Step 6: Update Parent Task File (if subtasks created)

Add `## Subtasks` section after frontmatter with Obsidian links as checklist items:

```markdown
## Subtasks

- [ ] [[parent_task_1_subtask_name]]
- [ ] [[parent_task_2_subtask_name]]
```

Also add the same subtask list to the AGENTS.md.

## Step 7: Confirm & Summarize

Show summary and confirm:

- AGENTS.md created
- Task type: [type]
- Activity: [activity]
- Document type: [type] (if writing)
- Context files loaded: [count]
- Subtask files created: [count or "none"]
- Jira tickets: [count or "none"] (if work task)
- Ready to start
