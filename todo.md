# todo

## Quick wins

- **`bin/update-submodules --prune`** — handle the "submodule removed upstream" case. Today, a deleted entry in `.gitmodules` leaves stale `aspects/.../<name>` dirs behind. Grow `bin/update-submodules` so it detects entries that exist on disk but no longer appear in `.gitmodules` and runs `git submodule deinit -f` + `rm -rf` for each. Smallest-scoped item left on the list.

- **Verify `bin/bootstrap` end-to-end on a fresh VM/Mac.** Everything wired tonight (xcode → brew → brew bundle → chsh → `bin/setup`) is plausible but never actually run on a clean box. A UTM/Lima/throwaway-user pass would catch any sequencing bugs before the next real new-machine moment.

## Bigger pieces

- **Cross-platform (Linux) support.** Estimate: 3–5 hours of code + however long Linux testing actually takes. The aspect pattern already does most of the work — `aspects/macos/` self-skips, pure-symlink aspects (`tmux`, `git`, `nvim`, `dotfiles`) work on Linux as-is. Real surface area:

  - **Decide which Linux first.** Ubuntu/Debian alone is one path of work; "any Linux" is several. Pick one and document.
  - **Add `bin/lib/platform.sh`** with `is_macos` / `is_linux` / `pkg_install` helpers, source from every setup that needs to branch. Pays for itself immediately.
  - **`bin/bootstrap`** — replace the `uname -s != Darwin` guard with a `case` that has a Linux phase: detect apt/dnf, install build essentials, install Homebrew-on-Linux. Replace `dscl` shell detection with `getent passwd $USER`.
  - **`aspects/homebrew/`** — Linux brew doesn't support casks. Cleanest split: `Brewfile` (shared CLI tools) + `Brewfile.macos` (casks, `pinentry-mac`) + `Brewfile.linux` (`pinentry`). Setup picks based on platform.
  - **`aspects/dotfiles/files/.bashrc`** — add `/home/linuxbrew/.linuxbrew/bin/brew` to the brew path probe. Gate the Obsidian PATH and `BASH_SILENCE_DEPRECATION_WARNING` behind a Darwin check.
  - **`aspects/ssh/files/config`** — `UseKeychain yes` warns on Linux. Either add `IgnoreUnknown UseKeychain` at the top of the `Host *` block (cleanest one-liner) or split into platform configs.
  - **`aspects/gnupg/`** — `pinentry-mac` vs Linux's `pinentry-curses` / `pinentry-gtk2`. Platform-conditional `pinentry-program` in `gpg-agent.conf`.
  - **Fonts** — no `brew cask` on Linux. Either `fc-cache` from a downloaded Nerd Font archive or distro font packages.
  - **The hidden tax**: SSH-agent + signing-key UX is meaningfully different on Linux (no Keychain — `gnome-keyring`, `KWallet`, or vanilla `ssh-agent`). Pick one and document the lifecycle. Clipboard helpers also differ (`pbcopy` → `xclip` / `wl-copy`).


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

- `aspects/homebrew/` (Brewfile + setup) — CLI tools, Nerd Font, GUI casks, jq.
- `aspects/claude-code/` — installs the Claude Code CLI via `claude.ai/install.sh`, symlinks `~/.claude/CLAUDE.md` + `~/.claude/settings.json` from the aspect, hosts a `plugins/marketplaces.json` manifest, and on setup adds marketplaces + installs every plugin listed in `settings.json` `enabledPlugins`. Optional `commands/`/`agents/`/`skills/`/`hooks/` dirs symlinked-if-present.
- `aspects/macos/` — system defaults (natural scrolling off, key repeat, finder, dock, screenshots, etc.).
- `aspects/ssh/` — shared `config` with multiplexing + keychain, includes `~/.ssh/config.local`, backs up any existing real file.
- `aspects/git/files/.gitconfig.local.template` + in-place hydration: setup auto-fills `signingkey` from `~/.ssh/id_ed25519.pub` when it appears, only ever replaces the literal `REPLACE_ME` so hand-edits are safe.
- `bin/bootstrap` — xcode-select → Homebrew → `brew bundle` (so modern bash is on PATH before aspect setups) → adds brew bash to `/etc/shells` + `chsh` → `bin/setup`.
- `README.md` — quickstart, layout, fresh-machine sequence (bootstrap → ssh-keygen → add to GitHub → re-run setup).
- `CLAUDE.md` at repo root — aspect pattern, setup-script conventions, bootstrap flow notes, extension-point inventory.
