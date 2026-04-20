---
description: Finalize exploration by creating a concise summary with source links
agent: build
---

Finalize the exploration phase by producing a concise synthesis of all exploration documents.

## Process

### 1. Resolve Input Files

In order of priority:

1. If `$ARGUMENTS` provided, use that path (folder or file pattern)
2. Look for `01_Explore/` directory in current working directory
3. Fall back to all markdown files in current working directory

### 2. Confirm Input Files

Use mcp_question to list discovered files and ask:
"I found these exploration files — are these the right ones to summarize?"

If user says no or wants to adjust, ask for the correct path/files.

### 3. Read and Analyze

Read all confirmed files and analyze:

- Key findings and insights
- Common themes across documents
- Important evidence and data points
- Connections between different exploration areas

### 4. Synthesize Summary

Create a concise summary that:

- Captures the essence of what was explored
- Groups related findings logically
- Uses obsidian-style links back to source files: `[[filename]]` or `[[filename#section]]`
- Avoids purple prose — be direct and factual
- Focuses on what was learned, not how it was learned

### 5. Determine Output Location

- If input was from `01_Explore/` → write to `01_Explore/summary.md`
- If input was loose files → write to `exploration_summary.md` in same directory

### 6. Confirm Before Writing

Show the user:
- Output file path
- Brief preview of summary structure
- Ask: "Ready to write this summary?"

### 7. Write Summary File

Create file with frontmatter:

```yaml
---
tags: [explore, summary, writing]
---
```

Then write the summary content with obsidian links to source files.

### 8. Confirm Completion

Tell user:
- ✓ Summary created at [path]
- Source files referenced: [count]
- Ready for diagnosis step (use `/diagnose` command)
