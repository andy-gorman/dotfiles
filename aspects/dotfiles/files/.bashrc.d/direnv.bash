#!/usr/bin/env bash
# direnv - automatically load/unload environment variables based on directory

if command -v direnv &> /dev/null; then
    eval "$(direnv hook bash)"
fi
