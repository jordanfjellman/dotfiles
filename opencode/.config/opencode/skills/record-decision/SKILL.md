---
name: record-decision
description: >
  Record and document team decisions in a concise, decision-first format.
  Use this skill when asked to "record a decision", "document a decision",
  "log a decision", or "close the loop on" something. Produces formatted
  output for Slack, GitHub PR comments, Jira ticket comments, or Confluence.
---

# Record Decision

This skill captures team decisions through a structured interview, applies
genuine pushback where warranted, then produces a concise document optimized
for the reader's time. The decision statement comes first — context is
secondary for those who need the reasoning later.

---

## Phase 1: Interview

Ask these questions one at a time. Wait for each answer before proceeding.
After gathering answers, move to the pushback step before drafting.

### Questions

1. **What's the decision?**
   Ask the user to state the decision in one or two declarative sentences.
   Help them sharpen vague answers into something concrete.

2. **What prompted this?**
   What problem, question, or situation led to this decision? What
   constraints existed (time, cost, team capacity, technical limitations)?

3. **What alternatives were considered?**
   For each alternative, ask why it was rejected. If the user says "none",
   probe — there's almost always at least one alternative, even if it's
   "do nothing."

4. **Who was involved?**
   Who participated in making this decision? Who needs to know about it?

5. **Is this closing the loop on something?**
   Was this previously discussed in Slack, a meeting, or a PR? If yes,
   note the context so the output can reference it.

### Pushback

After gathering answers, review the decision and alternatives with genuine
devil's advocate intent. If you see a real alternative worth considering:

- Raise it with a concrete reason, not filler like "have you considered..."
- Be brief — one or two sentences per counter-point
- If the user dismisses it, accept and move on
- If the user incorporates it, update the decision accordingly

Do NOT pushback for the sake of it. Only raise alternatives that have
genuine merit based on the context provided.

---

## Phase 2: Draft

Produce the decision document using this exact structure:

```
**Decision:** [1-2 sentence declarative statement]

**Context:** [Why this came up, what constraints existed. Keep it tight.]

**Alternatives Considered:**
- [Alternative A] — [why not, in one sentence]
- [Alternative B] — [why not, in one sentence]

**Consequences:** [What this means going forward. What changes, what doesn't.]
```

### Rules

- Lead with the decision. A reader should understand the call in 5 seconds.
- Context supports the decision — it doesn't retell the whole story.
- Alternatives should be genuinely distinct options, not strawmen.
- Consequences should be honest about tradeoffs, not just positive spin.
- Total length should rarely exceed 15-20 lines. Respect the reader's time.
- Only include a Mermaid diagram if the decision involves system or flow
  changes that are meaningfully clarified by a visual. Do not add diagrams
  for organizational or process decisions.

---

## Phase 3: Destination

Ask where this decision should be posted. Multiple destinations are allowed.

### Options

| Destination  | Behavior |
|-------------|----------|
| **Slack**       | Format as copy-paste text. If closing the loop, prepend `</loop>` to the message. Output the formatted text for the user to paste manually. |
| **GitHub PR**   | Ask for the PR URL. Show the draft comment. Confirm before posting via `gh pr comment`. User may choose to copy-paste instead. |
| **Jira**        | Ask for the ticket key. Show the draft comment. Confirm before posting via Atlassian MCP `jira_add_comment`. User may choose to copy-paste instead. |
| **Confluence**  | Create or append to a decision page in the DCE space (`Digital Content Engagement`). The page or folder structure is managed by the user — ask where it should go if unclear. |

### Destination-specific formatting

**Slack:**
```
</loop> (if closing the loop)

*Decision:* [statement]

*Context:* [why]

*Alternatives Considered:*
• [Alt A] — [why not]
• [Alt B] — [why not]

*Consequences:* [what this means]
```

**GitHub PR / Jira:**
Use markdown formatting (bold, bullet lists). Same structure as the draft.

**Confluence:**
Use markdown. Each decision entry should be separated by a horizontal rule
(`---`) if appending to an existing page. Newest decisions go at the top.

### Confirmation

For GitHub and Jira destinations, ALWAYS show the formatted draft and ask
for explicit confirmation before posting. Present two options:
1. Post it automatically
2. Copy-paste it yourself

Never auto-post without confirmation.
