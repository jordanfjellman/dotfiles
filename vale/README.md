# Vale

Prose linter. Markup-aware, so it lints the prose in a Markdown file and leaves
code fences, frontmatter, and link targets alone.

Installed by mise. Config is `.vale.ini`, found automatically at
`~/.config/vale/.vale.ini`. Confirm with `vale ls-dirs`.

## Split with Harper

Harper (`harper-ls`, also from mise) owns grammar, spelling, and mechanics.
Vale owns style and readability. Neither is configured to check what the other
checks, so anything flagged has one owner and one place to silence it. Harper's
`LongSentences` is switched off in `nvim/.config/nvim/after/lsp/harper_ls.lua`
because `Jordan.SentenceLength` covers it with Hemingway's two thresholds.

## After a fresh clone

`Packages` are downloaded, not committed:

```shell
vale sync
```

Nothing downloaded is committed, so until this runs every `write-good.*` rule
silently does nothing.

Downloads stay out of the repo by structure rather than by `.gitignore`. `vale`
is listed in `install`'s `NO_FOLDING`, so stow builds `~/.config/vale/styles` as
a real directory holding one symlink per file I wrote, instead of collapsing the
whole directory into a single link into this repo. `vale sync` then writes
`write-good/` beside them, on the machine, where git never sees it.

That means a new style needs no bookkeeping: add the directory and commit it.
The alternative, a `styles/*` exclusion with a whitelist per style, has to be
extended for every new one and fails silently when it isn't. The rules keep
working on this machine and are simply absent on the other.

## The Jordan style

| Rule                | What it does                                            |
| ------------------- | ------------------------------------------------------- |
| `SentenceLength`    | Over 20 words in a sentence. Hemingway's yellow.        |
| `VeryLongSentence`  | Over 35 words. Hemingway's red.                          |
| `Readability`       | Flesch-Kincaid grade for the document, target 9.        |
| `EmDash`            | No em dashes; readers read them as LLM output.          |

Sentence length is two rules rather than one because Vale has no notion of
severity tiers within a rule, and the yellow/red split is the part of Hemingway
worth keeping.

## The Agents style

For documents an agent reads: `AGENTS.md`, `CLAUDE.md`, `SKILL.md`, and anything
under `agents/`, `commands/`, or `skills/`.

| Rule       | What it does                                     |
| ---------- | ------------------------------------------------ |
| `Negation` | Flags a prohibition. State the target behaviour. |

An agent is a different reader with different failure modes. Prohibition is the
big one: naming a forbidden behaviour puts it in context and makes it more
available, and the negation is a weak modifier the activated concept overruns.

Sentence length and passive voice still apply, because a step whose actor is
implicit is a step that gets skipped. `EmDash` and `Readability` are off. The em
dash rule exists because human readers treat it as a tell, and a grade-level
target says little about a document full of technical vocabulary.

What Vale cannot see here is most of what makes these documents work: no-ops,
duplicated meaning, sprawl, weakly worded pointers, fuzzy completion criteria.
Those need a reader that understands the text.

## Per-document-type rules

Sections in `.vale.ini` apply in order, so a later one refines the base rather
than replacing it. `[README.md]` promotes `SentenceLength` to an error. Add a
section per document type that has earned different limits.

Give every section a `**/` prefix. Vale matches a section against the path as it
was given, so a bare `[AGENTS.md]` matches only a file invoked at the repo root
and silently misses `pi/.pi/agent/AGENTS.md`.

## Editors

- **Neovim**: nvim-lint, wired in `lua/fjellyvim/plugins/linting.lua`. It pipes
  the buffer over stdin, so the config passes `--path` to keep filename-scoped
  sections working.
- **Obsidian**: the `vale-linter` community plugin. It shells out to the binary,
  so it needs the absolute path (`~/.local/share/mise/installs/vale/latest/vale`)
  since a GUI app doesn't inherit the shell's `PATH`.
