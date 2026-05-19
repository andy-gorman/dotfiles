# Working in this repo

Personal macOS dotfiles. Read this before editing anything.

## Aspect pattern

Everything user-configurable lives in `aspects/<name>/`. Each aspect is self-contained:

```
aspects/<name>/
  bin/setup     # idempotent script; runs whatever this aspect needs to install/symlink
  files/        # tracked configs that get symlinked into $HOME (or wherever)
```

`bin/setup` at the repo root globs `aspects/*/bin/setup` in **alphabetical order** and runs each. There is no dependency declaration — aspects must be either independent or named so the order works (e.g., `homebrew` runs before `nvim` because Brewfile installs neovim).

**Adding an aspect:** make the directory, drop in `bin/setup` (executable, `#!/usr/bin/env bash`, `set -e`). It's picked up automatically.

## Setup script conventions

- `#!/usr/bin/env bash` shebang. Modern bash features (`mapfile -d ''`, etc.) are fine — `bin/bootstrap` installs brew bash before running aspect setups.
- `set -e` at the top.
- Idempotent. Re-running a setup must be safe; existing real files get backed up (`.backup.<timestamp>`), existing symlinks get `ln -sf`'d.
- `shellcheck` clean. CI runs `bin/format` which lints all `*.sh` + bash-shebang scripts under `bin/` and `aspects/*/bin/`.
- For files Claude/tools write to (e.g. `~/.claude/settings.json`): symlink so writes auto-version into the repo as diffs.

## Bootstrap flow

`bin/bootstrap` is the one-command fresh-Mac entry point:

1. Xcode CLT install
2. Homebrew install
3. `brew bundle` (via `aspects/homebrew/bin/setup`) — runs early so modern bash and other tools are on `PATH` before downstream aspect setups execute their shebangs.
4. Adds brew bash to `/etc/shells` and `chsh` to it
5. `bin/setup` — runs every aspect

Don't reorder these phases in `bin/bootstrap` without thinking about the bash-version problem.

## Extension points (local-only, untracked)

Three patterns let machine-specific config coexist with shared dotfiles:

| Path | Purpose | Sourced/included by |
|---|---|---|
| `~/.bashrc.work.d/*.bash` | Per-machine/job env exports (e.g., work repo paths) | `~/.bashrc` |
| `~/.gitconfig.local` | Per-machine git identity (signing key, optional email override) | `~/.gitconfig` |
| `~/.ssh/config.local` | Per-machine SSH hosts (work bastions, internal hosts) | `~/.ssh/config` |

These are intentionally **not** tracked. If you find yourself adding machine-specific values to a tracked file, route them through one of these instead.

## Submodules

External tooling (nvim plugins, base16 themes) is vendored via git submodules under `aspects/<aspect>/.../`. See `.gitmodules`. Updates flow through `bin/update-submodules`.

## What lives at the repo root

- `bin/bootstrap` — fresh-Mac one-shot.
- `bin/setup` — aspect runner.
- `bin/format` — stylua + shellcheck.
- `bin/update-submodules` — submodule pull/update.
- `README.md` — user-facing docs.
- `todo.md` — work-in-progress backlog.
- `.tmux` and `.zellij-layout.kdl` — project-local session configs for working *in this repo* (consumed by the tmux/zellij wrapper functions in `aspects/dotfiles/files/.bashrc.d/`).
