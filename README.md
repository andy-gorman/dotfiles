# dotfiles

Personal macOS dotfiles, organized as composable **aspects**.

## New machine setup

```bash
git clone --recursive git@github.com:<you>/dotfiles.git ~/Development/dotfiles
cd ~/Development/dotfiles
bin/bootstrap
```

`bin/bootstrap` is idempotent and handles a fresh Mac end-to-end:

1. Installs the Xcode Command Line Tools.
2. Installs Homebrew.
3. Runs `brew bundle` from `aspects/homebrew/Brewfile` (modern bash, neovim, tmux, fonts, etc.).
4. Adds the brew-installed bash to `/etc/shells` and `chsh`'s your login shell to it.
5. Runs `bin/setup`, which symlinks every aspect's config into `$HOME`.

Open a new login shell after it finishes.

## Fresh-machine sequence

A fresh Mac needs an SSH key before signed commits or `git push` work. The bootstrap intentionally doesn't generate one (passphrase choice + adding the key to GitHub are deliberate, out-of-band steps). Order:

1. `bin/bootstrap` — installs everything and symlinks configs. `~/.gitconfig.local` is created with `REPLACE_ME` as the signing key because no key exists yet.
2. Generate an SSH key:
   ```bash
   ssh-keygen -t ed25519 -C "you@example.com"
   ```
3. Add the public key to GitHub (and any other relevant SSO/work systems):
   ```bash
   pbcopy < ~/.ssh/id_ed25519.pub
   # paste into https://github.com/settings/keys
   ```
4. Re-run `bin/setup`. The git aspect finds the new public key and replaces the literal `REPLACE_ME` in `~/.gitconfig.local` with it. If you've already hand-edited that file, the placeholder is gone and the setup leaves your file untouched.

After that, signed commits, `git push`, and `gh` should all work.

## Layout

```
bin/
  bootstrap          # fresh-machine entry point
  setup              # symlink-only; runs every aspect's bin/setup
  format             # stylua + shellcheck across the repo
  update-submodules
aspects/
  homebrew/          # Brewfile + brew bundle wrapper
  claude-code/       # installs the Claude Code CLI from claude.ai/install.sh
  dotfiles/          # .bashrc, .bash_profile, .bashrc.d/*, .ripgreprc, base16-shell
  git/               # .gitconfig, .global_gitignore, hooks
  gnupg/             # gpg.conf, gpg-agent.conf
  nvim/              # ~/.config/nvim (submodule plugins under pack/)
  tmux/              # .tmux.conf, plugins
```

## Adding an aspect

1. `mkdir -p aspects/<name>/{bin,files}`
2. Write `aspects/<name>/bin/setup` (executable, `#!/usr/bin/env bash`, `set -e`) that symlinks files into `$HOME`.
3. That's it — `bin/setup` discovers it automatically via `aspects/*/bin/setup`.

## Local / work-specific overrides

The shared `.bashrc` sources two extension points that are **not** tracked here:

- `~/.bashrc.d/*.bash` — populated by aspect setup scripts (tracked indirectly).
- `~/.bashrc.work.d/*.bash` — drop machine- or job-specific exports here. Not in git.

The `.gitconfig` likewise includes `~/.gitconfig.local` for per-machine git settings.

## Re-running

Every script is idempotent. After pulling updates:

```bash
bin/update-submodules   # if submodules moved
bin/setup               # re-symlink + re-run brew bundle
```
