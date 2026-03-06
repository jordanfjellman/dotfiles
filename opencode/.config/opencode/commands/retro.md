---
description: "Session retro — usage: /retro <session-id> (find IDs via `opencode session list`)"
subtask: true
---

Analyze the following OpenCode session and produce a retrospective. The goal is to identify patterns that can improve future sessions — better prompts, better context loading, better tool usage, and opportunities to codify repeated workflows into commands or skills.

## Session Data

!`opencode export $1`

## Existing Commands

These are the user's current custom commands. Reference them when suggesting improvements or new commands.

!`ls -1 ~/.config/opencode/commands/`

## Existing Skills

These are the user's current agent skills. Reference them when suggesting improvements or new skills.

!`ls -1 ~/.config/opencode/skills/`

## Analysis Framework

Evaluate the session across these dimensions:

### 1. Context Loading Efficiency

- Were the right context files (AGENTS.md, coding philosophy, language-specific, etc.) loaded at the start, or did the LLM have to discover them mid-conversation?
- Were any context files loaded that weren't needed?
- Were any context files missing that would have prevented wasted turns?

### 2. Prompt Clarity

- How many clarification rounds were needed? Which prompts caused them?
- Were instructions specific enough on the first try?
- Could any prompts have been more concise or more precise?

### 3. Tool and MCP Usage

- Were the right tools used for each task (e.g., Task agent for exploration vs. direct Grep/Glob)?
- Were MCP servers (Jira, Confluence, GitHub, Brave, Expo) used when they should have been?
- Were there missed opportunities to use available tools?

### 4. Mode Usage

- Was Plan mode used when it should have been (complex features, architecture decisions)?
- Was Build mode used when Plan mode would have saved rework?

### 5. Workflow Patterns

- Were there repeated actions that could be extracted into a new command?
- Were there knowledge gaps that could be addressed by a new skill?
- Were there context patterns that should be added to an existing AGENTS.md file?

### 6. Session Flow

- Was the task broken down effectively, or was it too monolithic?
- Were TodoWrite tasks used to track progress?
- Was the conversation efficient, or were there unnecessary tangents?

## Output Format

Structure the retro as follows:

### What Went Well

List 3-5 specific things that worked effectively in this session. Be concrete — reference specific prompts, tool choices, or patterns that were efficient.

### What Needs Improvement

List 3-5 specific friction points. For each one:
- Describe what happened
- Explain why it was suboptimal
- Suggest what should have been done instead

### Action Items

Provide concrete, actionable changes. Categorize each as one of:

- **Command**: A new command to create or an existing one to modify (include the filename and a brief description of what it should do)
- **Skill**: A new skill to create or an existing one to update
- **Context**: An update to an AGENTS.md or other context file (specify which file and what to add)
- **Habit**: A workflow habit to adopt (e.g., "always start coding tasks with /init-task")
- **Prompt Pattern**: A reusable prompt structure for a common task type

For each action item, indicate effort level: quick (< 5 min), medium (5-30 min), or involved (> 30 min).

### Session Score

Rate the session 1-5 on each dimension:
- Context Loading: X/5
- Prompt Clarity: X/5
- Tool Usage: X/5
- Workflow Efficiency: X/5
- Overall: X/5

One sentence on what would have had the biggest impact if done differently.
