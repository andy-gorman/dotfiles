# todo

## Quick wins

- **`bin/update-submodules --prune`** — handle the "submodule removed upstream" case. Today, a deleted entry in `.gitmodules` leaves stale `aspects/.../<name>` dirs behind. Grow `bin/update-submodules` so it detects entries that exist on disk but no longer appear in `.gitmodules` and runs `git submodule deinit -f` + `rm -rf` for each. Smallest-scoped item left on the list.

- **Verify `bin/bootstrap` end-to-end on a fresh VM/Mac.** Everything wired tonight (xcode → brew → brew bundle → chsh → `bin/setup`) is plausible but never actually run on a clean box. A UTM/Lima/throwaway-user pass would catch any sequencing bugs before the next real new-machine moment.

## Bigger pieces

- **Submodule pinning to official releases.** Most submodules currently track `branch = main` / `master`. Pinning to tagged releases would make updates intentional rather than drive-by. Touches every entry in `.gitmodules`; worth its own session.

- **Neovim LSP overhaul** — three related pieces, probably one session:
  - Prettier as a formatter for JS/TS/JSON/etc.
  - JS/TS LSPs (tsserver, eslint).
  - Per-project LSP configs via `.nvim.lua` or similar so work repos vs personal repos can diverge.

- **Terminal emulator aspect.** No config tracked for Ghostty / iTerm / Alacritty / WezTerm right now. Pick one (or two) and add `aspects/<terminal>/` with the config file + setup script.

## Probably-already-handled

- ~~Project-specific ripgrep files.~~ `rg` reads `.rgignore` from the project root natively — no dotfiles change needed. Just need to remember the pattern.

- ~~tmux per module / project.~~ The existing tmux wrapper function in `aspects/dotfiles/files/.bashrc.d/tmux.bash` already runs a project-local `.tmux` file (with TOFU trust prompt). The repo's own root-level `.tmux` is an example of this pattern. So this is more a habit reminder than a code task.

## Done in the new-machine pass (2026-05)

- `aspects/homebrew/` (Brewfile + setup) — CLI tools, Nerd Font, GUI casks.
- `aspects/claude-code/` — installs Claude Code via `claude.ai/install.sh`.
- `aspects/macos/` — system defaults (natural scrolling off, key repeat, finder, dock, screenshots, etc.).
- `aspects/ssh/` — shared `config` with multiplexing + keychain, includes `~/.ssh/config.local`, backs up any existing real file.
- `aspects/git/files/.gitconfig.local.template` + in-place hydration: setup auto-fills `signingkey` from `~/.ssh/id_ed25519.pub` when it appears, only ever replaces the literal `REPLACE_ME` so hand-edits are safe.
- `bin/bootstrap` — xcode-select → Homebrew → `brew bundle` (so modern bash is on PATH before aspect setups) → adds brew bash to `/etc/shells` + `chsh` → `bin/setup`.
- `README.md` — quickstart, layout, fresh-machine sequence (bootstrap → ssh-keygen → add to GitHub → re-run setup).
