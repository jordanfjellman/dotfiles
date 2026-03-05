---
description: End of Day — wind down and capture the day
agent: build
---

End the day by walking through a short checklist, confirming task completion, and summarizing what happened into the weekly note. The goal is to get everything out of your head so you can leave work at work.

## Constants

- Vault name: `notes`
- Vault path: `~/code/personal/notes`
- Daily notes path: `Objectives and Reviews/Daily`
- Weekly notes path: `Objectives and Reviews/Weekly`
- Daily note format: `YYYY-MM-DD.md`
- Weekly note format: `YYYY-[W]ww.md`
- Template reference: `Templates/Daily.md`

## Process

### 1. Determine Dates

Calculate:

- Today's date as `YYYY-MM-DD`
- Current ISO week number and year for the weekly note filename (e.g., `2026-W09`)

### 2. Ensure Today's Note Exists

Check if `{Vault path}/{Daily notes path}/{today}.md` exists.

- If it **exists**, read it and continue.
- If it **does not exist**:
  - Open Obsidian to trigger note creation:
    ```bash
    open "obsidian://open?vault=notes&file=Objectives%20and%20Reviews%2FDaily%2F{today}"
    ```
  - Tell the user: "Today's daily note doesn't exist yet. I've opened Obsidian — please create the note there so the template is applied correctly."
  - Use `mcp_question` to ask: "Has the note been created?"
  - Once confirmed, re-read the file.

### 3. Walk Through the End-of-Day Checklist

The checklist items come from the `### End-of-Day Checklist` section in today's note (per `Templates/Daily.md`). Walk through each one interactively:

---

#### 3a. Process consumed content or meetings

Ask the user:

> **Process consumed content or meetings attended today.**
>
> Is there anything from today's meetings or content you consumed that you'd like to capture?

- If **yes**: Accept freeform input. Append each entry as a bullet point to the `## Log` section of today's note. Ask if there's more to add. Repeat until done.
- If **no**: Move on.

Mark this checklist item as `- [x]` in the note.

---

#### 3b. Inbox Zero

Ask the user:

> **Inbox Zero check.** Have you gotten to Inbox Zero on all email accounts?

- If **yes**: Mark as `- [x]`.
- If **no**: Mark as incomplete. Optionally ask if they want to add a reminder to tomorrow's plan (this will be picked up by SOD's carry-forward check).

---

#### 3c. Confirm tasks completed

Read the `### Today, I need to...` section from today's note. Display the task list.

Ask the user:

> Here are the tasks you planned for today:
>
> {numbered list of tasks}
>
> Which ones did you complete? (Enter the numbers, e.g., "1, 3, 4" — or "all" / "none")

- Update completed tasks to `- [x]` in the note.
- For incomplete tasks, leave them as `- [ ]`. These will be surfaced by SOD tomorrow via the carry-forward check.

Mark this checklist item as `- [x]`.

---

#### 3d. Knowledge sharing check

Ask the user:

> **Is there any knowledge you should be sharing with the team?**
>
> Think about things you learned, decisions you made, or context that would help others.

- If **yes**: Accept freeform input. Append each entry as a bullet to the `## Log` section prefixed with `[share]` (e.g., `- [share] Learned that the CDK stack needs explicit dependencies`). These `[share]` entries signal that a task should be created in tomorrow's daily note (via SOD carry-forward) to actually share the knowledge with the team. Ask if there's more to add. Repeat until done.
- If **no**: Move on.

Mark this checklist item as `- [x]` in the note.

---

#### 3e. Summarize daily log into weekly note

Read the `## Log` section from today's note.

- If the log is **empty** (just the placeholder `- `), tell the user: "No log entries for today. Skipping the weekly summary." Mark as `- [x]` and move on.
- If the log **has content**:
  1. Generate a concise summary of the log entries — a few bullet points capturing the key things that happened. Keep it brief and factual.
  2. Present the draft to the user:

> Here's a draft summary for the weekly note:
>
> {draft summary}
>
> Does this look good, or would you like to change anything?

3. If the user wants changes, revise and re-present until approved.
4. Once approved, read the weekly note at `{Vault path}/{Weekly notes path}/{weekly-note}.md`.
   - If the weekly note **does not exist**, warn the user and skip this step.
   - If it **exists**, append the summary under the `## Weekly Log` section, formatted as:

```markdown
### [[{YYYY-MM-DD}|{Day of week}, {Month} {Day ordinal}]]

{approved summary}
```

5. Mark this checklist item as `- [x]` in today's note.

### 4. Final Update

Write all accumulated changes to today's daily note (updated checklist items and any log additions).

### 5. Open in Obsidian

Open today's note:

```bash
open "obsidian://open?vault=notes&file=Objectives%20and%20Reviews%2FDaily%2F{today}"
```

### 6. Wind-Down Message

Print a short closing message:

> Day's wrapped. Everything's been captured and your weekly note is updated. Go rest up.
