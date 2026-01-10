#!/usr/bin/env bash
# Terminal color scheme configuration

# Tinted Shell (base16 color schemes)
export TINTED_SHELL_ENABLE_BASE24_VARS=1

# shellcheck disable=SC1091
if [[ -r "$HOME/.config/base16-shell/scripts/base16-nord.sh" ]] && [[ -f "$HOME/.config/base16-shell/scripts/base16-nord.sh" ]]; then
    source "$HOME/.config/base16-shell/scripts/base16-nord.sh"
fi
