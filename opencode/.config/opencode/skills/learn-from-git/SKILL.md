---
name: learn-from-git
description: >
  Analyze a codebase to discover repeating development patterns and generate
  new SKILL.md files that encode them. Uses structural analysis and git
  co-change frequency to identify patterns, then git blame to extract details.
  Use when asked to "learn a skill", "discover patterns", "what skills should
  we build", or "teach yourself how we do X".
---

## Purpose

You are a meta-skill. Your job is to analyze how developers in a codebase have
implemented repeating types of work, then produce new SKILL.md files that
capture those patterns. The generated skills can then be used by agents
(including yourself) to replicate the pattern on future tasks.

You operate in two modes:

- **Discover** — Scan the repo to identify candidate patterns worth encoding
- **Extract** — Given a specific pattern, analyze exemplars and generate a SKILL.md

## When to activate

- User asks to "discover patterns", "what skills should we build", or "analyze
  this repo for patterns" → **Discover mode**
- User asks to "learn how we do X", "create a skill for X", or "teach yourself
  how we do X" → **Extract mode**
- User references a specific module, directory, or Jira ticket and wants to
  generalize from it → **Extract mode**

---

## Mode 1: Discover

Goal: Identify repeating development patterns in the repo and present them as
candidate skills worth building. Require at least 2 instances of a pattern
before surfacing it.

### Step 1: Build a commit density profile

Before analyzing patterns, understand the repo's development timeline. Build a
month-by-month commit frequency histogram:

```bash
git log --format="%aI" | cut -d'T' -f1 | cut -d'-' -f1,2 | sort | uniq -c | sort -k2
```

Use this to identify:

- **Foundational periods** — Early bursts when the repo structure was
  established. These define the original patterns.
- **Recent spikes** — Active development in the last few months. These show
  what's relevant now and may reveal evolved patterns.
- **Quiet periods** — Can be deprioritized in co-change analysis.

Set an adaptive analysis window: default to the last 12 months, but extend
further back if the histogram shows significant foundational activity that
established patterns still in use today. If most commits cluster in a specific
window, note that and weight it accordingly.

### Step 2: Structural scan

Walk the directory tree and fingerprint each top-level module by its internal
file and folder shape. This requires no git history at all.

```bash
# List top-level directories
ls -d */

# For each top-level directory, get its internal structure
# Compare the shapes across directories
find <dir> -type f | sed "s|^<dir>/||" | sort
```

For each top-level directory, produce a "shape fingerprint" — the set of
relative file paths within it, with names generalized (e.g., replace
`VodHandler.scala` with `*Handler.scala`).

Group directories that share the same shape. If 3+ directories all contain
`src/main/scala/.../Handler.scala`, `src/main/scala/.../Events.scala`, and
`src/main/scala/.../State.scala`, that's a strong candidate pattern.

Report findings like:

> **Candidate: Domain Module Pattern** (5 instances)
> Directories: `vod/`, `ebook/`, `study-progress/`, `live-event/`, `access/`
> Common shape: Handler, Events, State, Aggregate files in `src/main/scala/`
> with corresponding infrastructure in `infrastructure/`

### Step 3: Co-change clustering

Identify files that frequently change together. This uses git history but
ignores commit messages entirely — only the file groupings matter.

```bash
# Get file sets per commit (messages discarded)
git log --name-only --pretty=format:"COMMIT_BOUNDARY" -- . | \
  awk '/^COMMIT_BOUNDARY$/{if(NR>1) print "---"; next} NF{print}'
```

Parse the output into per-commit file sets. Then build a co-occurrence matrix:
for each pair of files that appear in the same commit, increment their
co-occurrence count.

**Jira ticket grouping:** Before building co-occurrence, check if commit
messages contain ticket IDs (pattern: `[A-Z]+-\d+`). If they do, group all
commits sharing the same ticket ID into a single logical changeset before
counting co-occurrences. This handles the common case where a developer makes
multiple commits for one task.

```bash
# Extract ticket IDs from commit messages
git log --format="%H %s" | grep -oE '[A-Z]+-[0-9]+'

# Group commits by ticket ID
git log --format="%H %s" | while read hash msg; do
  ticket=$(echo "$msg" | grep -oE '[A-Z]+-[0-9]+' | head -1)
  if [ -n "$ticket" ]; then
    echo "$ticket $hash"
  fi
done
```

When ticket IDs are present, merge the file sets of all commits sharing a
ticket ID into one changeset. This produces cleaner co-change clusters because
it groups files that belong to the same logical unit of work.

Cluster the co-occurrence data. Look for groups of 3+ files that consistently
change together. Filter out noise (files that change with everything, like
`build.sbt` or `package.json`).

Weight co-occurrences by the adaptive window from Step 1: recent changes count
more, but foundational patterns still register if they're structurally repeated.

### Step 4: Author attribution

For each candidate pattern identified in Steps 2-3, run a git blame summary on
the exemplar files to identify which developers own the pattern:

```bash
# For each exemplar file in a candidate pattern
git blame --porcelain <file> | grep "^author " | sort | uniq -c | sort -rn
```

This reveals:
- Whether one developer authored most instances (single source of knowledge)
- Whether the pattern was adopted by multiple developers (team convention)
- Who to consult for clarification during skill review

### Step 5: Rank and present

Score each candidate pattern by:

1. **Instance count** — How many completed examples exist (minimum 2)
2. **Consistency** — How similar the instances are to each other
3. **Recency** — How recently the pattern was used (from commit density profile)
4. **Breadth** — How many files/directories are involved (broader patterns =
   higher value skills)

Present a ranked list to the user:

```
## Discovered Patterns

### 1. Domain Module Pattern (5 instances, high confidence)
Directories: vod/, ebook/, study-progress/, live-event/, access/
Shape: Handler + Events + State + Aggregate in src/main/scala/
       with Lambda + API Gateway definitions in infrastructure/
Primary authors: [Developer A] (3 instances), [Developer B] (2 instances)
Last used: 2 months ago
Jira tickets: DCE-342, DCE-415, DCE-501 (when available)

### 2. SNS/SQS Integration Pattern (3 instances, medium confidence)
Files that co-change: infrastructure/*-topic.yaml, <module>/src/.../Consumer.scala
Primary author: [Developer C]
Last used: 4 months ago

...

Would you like me to extract a full skill for any of these?
```

---

## Mode 2: Extract

Goal: Given a specific task type (from discovery output or user input), analyze
exemplar instances and generate a SKILL.md that encodes the pattern.

### Step 1: Clarify the task type

Ask the user what type of task they want to learn. Examples:

- "Adding a new API endpoint"
- "Creating a new event-sourced aggregate"
- "Deploying SnowRecord resources for an aggregate"
- "Adding a new SNS/SQS integration between domains"

If the user provides a specific example (e.g., "look at how Study Progress does
it"), use that as the seed and infer the task type from it.

If coming from Discover mode, the task type and exemplars are already identified.

### Step 2: Identify exemplar files

Find 2-3 completed examples of the task type in the codebase. The user may
point you directly at a module or directory. If not, use the structural scan
and co-change data from Discover mode (or run those steps now if Discover
wasn't run first).

```bash
# Find directories that match the pattern
ls -d */

# Look for files with naming patterns that suggest the task type
find . -type f -name "*<pattern>*" 2>/dev/null

# Use git log sparingly as a discovery aid (not for learning)
git log --oneline --since="12 months ago" -- "<path-pattern>" | head -20
```

Aim for 2-3 completed examples. If you can only find 1, tell the user and
proceed with reduced confidence.

### Step 3: Analyze via git blame

For each exemplar, examine the code as it exists today using git blame to
understand both the content and its provenance:

```bash
# Understand who wrote each part and when
git blame --date=short <file>

# Get author summary for a file
git blame --porcelain <file> | grep "^author " | sort | uniq -c | sort -rn

# Overview of all files in a directory
for f in <directory>/*; do
  echo "=== $f ==="
  git blame --date=short "$f" | head -5
done
```

For each exemplar, read and categorize the files:

| Category | What to look for |
|----------|-----------------|
| **Domain/Handler code** | Handlers, controllers, aggregates, services in domain modules |
| **Infrastructure** | CloudFormation, CDK, Terraform, serverless config |
| **Tests** | Unit tests, integration tests, e2e tests |
| **Shared/Common** | Shared libraries, utilities |
| **Configuration** | Environment config, feature flags, application settings |

Use git blame dates to distinguish current practice from legacy code. If a file
was substantially rewritten recently, weight the current version heavily. If
blame shows the code hasn't been touched in years, flag it as potentially
outdated in the generated skill.

### Step 4: Extract the pattern

Compare across the exemplars. Look for:

1. **Consistent file structure** — Do all examples create files in the same
   directories? What naming conventions do they follow?
2. **Co-occurring files** — When a handler exists, what infrastructure files
   always accompany it?
3. **Boilerplate and structure** — Are there repeated code structures across
   examples? (e.g., every aggregate has the same base trait, every handler
   follows the same request/response shape)
4. **Cross-module dependencies** — Does a file in one module always have a
   corresponding file in another?
5. **Author patterns** — Does git blame reveal that one developer authored most
   examples? This identifies domain experts.

For ordering: since git blame doesn't reveal sequence, infer ordering from:
- Co-change data (if available from Discover mode): files that appear earlier
  in commit sequences within a Jira ticket grouping
- Directory nesting and naming (infrastructure often precedes handler code)
- File references (if file A's content references file B, B likely comes first)

Mark all inferred ordering with `[REVIEW: ordering]` for the developer to
validate.

### Step 5: Generate a SKILL.md

Produce a new SKILL.md that encodes the pattern. Follow this structure:

````markdown
---
name: <task-type-as-kebab-case>
description: >
  <What this skill does and when to use it. Be specific about keywords
  that would trigger activation.>
---

## Overview

<1-2 sentence summary of the pattern>

## Steps

<Numbered steps a developer (or agent) should follow to complete this type of
task. Each step should reference specific directories, file naming conventions,
and code patterns observed in the codebase.>

<Mark any ordering you're uncertain about with "[REVIEW: ordering]" for the
developer to validate.>

## File Checklist

<A checklist of files/directories that typically need to be created or modified
for this type of task.>

- [ ] `<path/to/file-pattern>`
- [ ] `<path/to/other-file-pattern>`

## Code Patterns

<Concrete code snippets extracted from the exemplars showing the structure and
conventions. These are from the code as it exists today, not from diffs.
Include repo-specific snippets that show exactly what the pattern looks like.>

## Examples

<Reference the specific exemplar modules/files you analyzed. Include which
developer authored them (from git blame) so the user knows who to consult.>

## Common Pitfalls

<Patterns where exemplars differ from each other in ways that suggest one
approach was corrected or improved. If git blame shows a section was recently
rewritten, the newer version likely represents a lesson learned.>
````

### Step 6: Present for review

Output the generated SKILL.md content to the chat. Include alongside it:

1. The full SKILL.md content in a code block
2. A summary of which exemplar files you analyzed
3. Which developers authored the exemplars (from git blame)
4. Your confidence level (how many instances, how consistent the pattern was)
5. Items flagged for developer review (especially ordering)

Do NOT write the file to disk. The user will review and place it.

---

## Limitations

- Requires at least 2 completed examples of a task type to surface a pattern.
  A single example is not sufficient.
- Git blame doesn't reveal ordering. Ordering is inferred from co-change data,
  file references, and directory structure, then flagged for developer review.
- Cannot observe deployment steps, manual configuration, or knowledge that
  lives outside the repo.
- If code has been substantially refactored, git blame may attribute lines to
  the refactoring author rather than the original pattern author.
- Co-change clustering can be noisy in repos with very large commits or
  frequent bulk reformatting. Files that change with everything (build files,
  lockfiles) should be filtered out.
- Jira ticket grouping depends on ticket IDs being present in commit messages.
  If the team doesn't reference tickets in commits, this signal is unavailable
  and co-change falls back to per-commit grouping.
- This skill is language-agnostic. It does not parse imports, ASTs, or
  language-specific constructs. Pattern detection is based entirely on file
  structure and git metadata.
