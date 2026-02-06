---
description: Create context-aware AGENTS.md for writing projects
agent: build
---

Initialize a writing project by creating a tailored AGENTS.md file.

## Process

### 1. Check for Existing File

If AGENTS.md exists, ask user: overwrite, append, or cancel?

### 2. Gather Project Info

Use mcp_question to ask (one question at a time, wait for response):

**a) Project type:**

- Strategy document (work) - ADRs, specs, technical docs for Lifeway
- Blog post (personal) - Public blog posts

**b) If Strategy Document:**

- Document type: ADR / Product Strategy / Technical Spec / Other
- Related Jira tickets (comma-separated like "PROJ-123, PROJ-456" or "none")
  - Fetch details with `jira_get_issue` for each ticket
  - On fetch failure, note ticket with status "Failed to fetch"

**c) If Blog Post:**

- Topic or theme

**d) Always ask:**

- Brief description of what you're trying to accomplish

### 3. Confirm & Create

Show summary and ask for confirmation before creating file.

### 4. Generate AGENTS.md

**Shared Base Template:**

```markdown
# Writing Project: [TYPE]

## Project Description

[User description]

## Reference Context

- Writing assistant: `@~/code/personal/notes/LLM Context/writing/AGENTS.md`
  [Type-specific context files]

## AI Collaboration Notes

**Core Principle: You write, AI assists.**

AI should:

- Structure thinking and improve clarity
- Challenge assumptions actively
- Identify reasoning gaps
- Suggest alternative perspectives
- Co-create outlines before writing
  [Type-specific additions]

AI should NOT:

- Write complete [documents/posts] for you
- Make decisions on your behalf
- Override your judgment
```

**Strategy Document Additions:**

- Context: `@~/code/personal/notes/LLM Context/writing/engineering/AGENTS.md`
- Context: `@~/code/personal/notes/LLM Context/lifeway/AGENTS.md`
- Jira table (if tickets provided)
- AI should: Generate visual diagrams (Mermaid) during refinement

**Blog Post Additions:**

- Topic section
- Context: `@~/code/personal/notes/LLM Context/writing/blog/AGENTS.md`
- Writing Reminders section (linking, citations, purpose)

### 5. Confirm Creation

Tell user:

- ✓ AGENTS.md created
- Project type: [type]
- Context files loaded: [count]
- Jira tickets: [count or "none"]
- Ready to start writing
