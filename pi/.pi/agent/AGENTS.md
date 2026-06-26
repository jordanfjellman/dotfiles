# Global Agent Preferences

## Shell

I primarily use **Fish** (`/opt/homebrew/bin/fish`) as my interactive shell. When
suggesting shell snippets, aliases, functions, abbreviations, or interactive
commands, prefer Fish syntax.

- Use Fish syntax for interactive/config examples: `set -gx VAR value`,
  `function name; ...; end`, `abbr`, `set -U`, `$status`, etc.
- Fish config lives in `fish/.config/fish/` in my dotfiles (`config.fish`,
  `conf.d/`, `completions/`, `functions/`).
- For **portable scripts** (things that live in `bin/.local/bin/` and run
  non-interactively), keep using `#!/usr/bin/env bash` / POSIX sh — those are
  invoked as programs, not sourced into my shell, so Bash is correct there.
- My login shell wiring also touches `zsh/.zshrc` (legacy keybinds) and tmux
  (`set-option -g default-shell /opt/homebrew/bin/fish`). When adding shell
  keybindings, mirror across Fish and zsh where it makes sense, but Fish is the
  source of truth.

## Environment

- macOS, APFS (copy-on-write `cp -c` / clonefile available).
- Dotfiles managed with GNU stow; each top-level dir (e.g. `fish/`, `tmux/`,
  `wt/`, `bin/`) is a stow package whose contents mirror `$HOME`.
- Tooling: mise (runtime versions), starship (prompt), ghostty (terminal),
  tmux + tmux-sessionizer for session management.

## Git worktree workflow

I use a bare-repo + worktree layout. Tooling lives in my dotfiles:

- `bin/.local/bin/wt` — `clone` / `new` / `list` / `clean` / `root`. Layout:
  `~/code/<area>/<repo>/{.bare,.git,.worktrees/,<branch dirs>}`.
- `bin/.local/bin/worktree-sessionizer` — fzf-pick a worktree → `tmux-sessionizer`
  (bound to `^g` in zsh, `prefix g` in tmux).
- `wt/.config/wt/setup.sh` — global post-`wt new` hook (cp -c clones
  node_modules/.env from the primary worktree, runs `mise install`).
- Per-repo overrides go in `<repo>/.worktrees/setup.sh`; canonical env files in
  `<repo>/.worktrees/env/`.

## Code Comments

Keep comments minimal. Default to none; add one only when it earns its keep
long-term. Rule of thumb: if hover, jump-to-definition, or `git blame` would
tell me, leave it out. If a new reader would guess *wrong* about *why*, write it.

- Don't restate what the code, types, or signatures already say — the LSP
  surfaces those on hover. No `// increments counter` above `count++`.
- Don't record history in code (who/when/what changed). That lives in commit
  messages, PR descriptions, and `git blame`. Use good commit hygiene instead.
- Comment the *why*, not the *what*: intent, non-obvious constraints,
  invariants, tradeoffs, gotchas, and workarounds — link the ticket/issue/spec
  that explains them.
- Avoid wordy prose; it gets skimmed and rots. One tight line beats a paragraph.
- `TODO`/`FIXME` only with a linked ticket; otherwise it's noise.

Doc comments are the exception — they're the structured comment the toolchain
surfaces, so they document the *contract* of public APIs:

- **Scala** — Scaladoc `/** */` (Metals shows it on hover). Describe behavior,
  `@throws`, and edge cases, not the types.
- **TypeScript** — TSDoc `/** */` with `@param`/`@returns`/`@example`/
  `@deprecated`. Never annotate types in tags; the compiler owns those.
- **JavaScript** — JSDoc `/** */`. Here type tags (`@param {string}`,
  `@returns {Promise<T>}`) *do* earn their place — there's no compiler, so the
  LSP relies on them for inference and checking.
- **Rust** — `///` for items, `//!` for module/crate docs (markdown, shown by
  rust-analyzer). Prefer runnable ```` ```rust ```` examples; `cargo test`
  compiles and runs them, so they can't rot.
- **Fish** — give functions a `--description`; it shows in completions and
  `functions`. That's the doc comment.
- **Bash/POSIX** — a short function header (purpose + meaning of `$1`/`$2`) and
  a usage/help string; keep `# shellcheck` directives where needed.

## Reference Context

Load additional context from "@/$HOME/notes/LLM Context/AGENTS.md" when present,
and pull in related context files based on the current session's focus.
