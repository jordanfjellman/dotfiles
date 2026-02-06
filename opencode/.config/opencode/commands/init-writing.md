---
description: Initialize a writing project with context-aware AGENTS.md
agent: build
---

Initialize a writing project in the current directory by creating an AGENTS.md file tailored to the project type.

## Instructions

You must ask the user questions to understand their writing project, then generate an appropriate AGENTS.md file. Use the mcp_question tool to ask questions interactively.

### Step 0: Check for Existing File

If AGENTS.md already exists in the current directory, ask the user if they want to:

- Overwrite it
- Append to it
- Cancel the operation

### Step 1: Ask Project Type

Ask the user what type of writing project this is:

- **Strategy document (work)** - Engineering strategies, ADRs, technical specs for Lifeway
- **Blog post (personal)** - Personal blog posts for sharing ideas publicly

### Step 2: Gather Project-Specific Details

**If Strategy Document:**

1. Ask what type of strategy document:
   - Architecture Decision Record (ADR)
   - Product Engineering Strategy
   - Technical Spec
   - Allow custom input

2. Ask if there are any related Jira tickets (optional). Accept comma-separated ticket keys like "PROJ-123, PROJ-456".

3. If Jira tickets are provided, use the `jira_get_issue` tool to fetch details for each ticket (summary, status, description). Include these details in the generated AGENTS.md.

**If Blog Post:**

1. Ask for the topic or theme of the blog post.

### Step 3: Get Project Description

Always ask for a brief description of what the user is trying to accomplish with this writing project.

### Step 4: Generate AGENTS.md

Create an `AGENTS.md` file in the current working directory with the following structure:

---

## Template for Strategy Documents

```markdown
# Writing Project: [Document Type]

## Project Description

[User-provided description]

## Reference Context

Load the following context files for this writing session:

- Writing assistant context: `@~/code/personal/notes/LLM Context/writing/AGENTS.md`
- Engineering strategy guidance: `@~/code/personal/notes/LLM Context/writing/engineering/AGENTS.md`
- Lifeway context: `@~/code/personal/notes/LLM Context/lifeway/AGENTS.md`

## Related Jira Tickets

[If tickets were provided, create a table with links and fetched details:]

| Ticket                                                        | Summary           | Status           |
| ------------------------------------------------------------- | ----------------- | ---------------- |
| [TICKET-123](https://lifeway.atlassian.net/browse/TICKET-123) | [Fetched summary] | [Fetched status] |

[If no tickets: "No Jira tickets linked to this project."]

## AI Collaboration Notes

**Core Principle: You write, AI assists.**

The AI should:

- Help structure your thinking and improve clarity
- Challenge your assumptions actively
- Identify gaps in reasoning and logic
- Suggest alternative perspectives to consider
- Co-create outlines before you write
- Generate visual diagrams (Mermaid) during refinement

The AI should NOT:

- Write complete strategies or ADRs for you
- Make decisions on your behalf
- Override your judgment and expertise
- Skip important steps in the process
```

---

## Template for Blog Posts

```markdown
# Writing Project: Blog Post

## Topic

[User-provided topic/theme]

## Project Description

[User-provided description]

## Reference Context

Load the following context files for this writing session:

- Writing assistant context: `@~/code/personal/notes/LLM Context/writing/AGENTS.md`
- Blog writing guidance: `@~/code/personal/notes/LLM Context/writing/blog/AGENTS.md`

## AI Collaboration Notes

**Core Principle: You write, AI assists.**

The AI should:

- Help structure your thinking and improve clarity
- Challenge your assumptions actively
- Identify gaps in reasoning and logic
- Suggest alternative perspectives to consider
- Co-create outlines before you write

The AI should NOT:

- Write complete blog posts for you
- Make decisions on your behalf
- Override your judgment and expertise

## Writing Reminders

- Link to other blog posts where relevant
- Cite external sources and references
- Blog posts serve to give you a place to think through a given problem space and provide a public link to share notes with others
```

---

### Error Handling

- If Jira ticket fetch fails, note the ticket key but continue
- If user provides invalid ticket format, ask them to correct it
- If mcp_question tool unavailable, fall back to parsing from initial prompt

## After Creating the File

Confirm to the user that the AGENTS.md file has been created and summarize:

- The project type
- Key context files that will be loaded
- Any linked Jira tickets (if applicable)
- Remind them they can start writing and the AI will assist based on this context
