---
description: Start of Day — plan your day with intention
agent: build
---

Start the day by reviewing yesterday's loose ends, ensuring today's daily note exists, and setting clear intentions for what needs to get done.

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
- Yesterday's date as `YYYY-MM-DD` (account for weekends — if today is Monday, yesterday is Friday)
- Current ISO week number and year for the weekly note filename (e.g., `2026-W09`)

### 2. Check Yesterday's Unfinished Business

Read yesterday's daily note at `{Vault path}/{Daily notes path}/{yesterday}.md`.

- If the file **does not exist**, skip this step silently (days off, weekends, etc.).
- If the file **exists**, read the `### End-of-Day Checklist` section.
  - If all items are `- [x]` (checked), skip this step.
  - If any items are `- [ ]` (unchecked), display them and ask:

> These items from yesterday's end-of-day checklist weren't completed:
>
> {list unchecked items}
>
> Would you like to address any of these now before planning today?

If yes, walk through each unchecked item briefly (same logic as the EOD checklist — see `eod.md` for details). If no, move on.

Also read yesterday's `### Today, I need to...` section:

- If any tasks are `- [ ]` (unchecked), display them and ask:

> These tasks from yesterday weren't completed:
>
> {list unchecked items}
>
> Should any of these carry forward to today's plan?

Note the user's response — carry-forward items will be pre-populated in step 5.

### 3. Ensure Today's Note Exists

Check if `{Vault path}/{Daily notes path}/{today}.md` exists.

- If it **exists**, read it and continue to step 4.
- If it **does not exist**:
  - Open Obsidian to trigger note creation via Periodic Notes + Templater:
    ```bash
    open "obsidian://open?vault=notes&file=Objectives%20and%20Reviews%2FDaily%2F{today}"
    ```
  - Tell the user: "Today's daily note doesn't exist yet. I've opened Obsidian — please create the note there so the template is applied correctly."
  - Use `mcp_question` to ask: "Has the note been created?"
  - Once confirmed, re-read the file to verify it exists.

### 4. Show Weekly Goals for Context

Derive the weekly note filename from today's date (e.g., `2026-W09.md`).

Read `{Vault path}/{Weekly notes path}/{weekly-note}.md`.

- If the file **does not exist**, tell the user: "No weekly note found for this week. You may want to create one in Obsidian."
- If it **exists**, find and display the `### 3 Goals for the Nth Week of YYYY` section content. Present it as:

> **This week's goals:**
>
> {goals content}

### 5. Prompt for Today's Plans

Ask the user:

> What do you need to get done today? List your tasks — one per line, or as a comma-separated list. These don't all have to be completable today; include anything on your mind that you'd like to work toward.

If there are carry-forward items from step 2, remind the user:

> Carried forward from yesterday:
> {list of items}
>
> These will be included unless you say otherwise. What else do you need to get done?

Take the user's input and:

1. Combine carry-forward items (if any) with new items
2. Format each as `- [ ] {item}`
3. Update the `### Today, I need to...` section in today's note, replacing the empty `- [ ]` placeholder with the full checklist

### 6. Open in Obsidian

Open today's note in Obsidian:

```bash
open "obsidian://open?vault=notes&file=Objectives%20and%20Reviews%2FDaily%2F{today}"
```

### 7. Summary

Print a short confirmation:

> Your day is set up. {N} tasks planned for today. Weekly goals are in view. Have a good one.
