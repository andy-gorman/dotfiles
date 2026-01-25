#!/usr/bin/env bash
# Node.js and JavaScript runtime configuration

# Note: bun PATH configuration is handled in the main .bashrc PATH section

# Volta - JavaScript tool manager
export VOLTA_HOME="$HOME/.volta"
export VOLTA_FEATURE_PNPM=1
if [ -d "$VOLTA_HOME" ]; then
    export PATH="$VOLTA_HOME/bin:$PATH"
fi
