#!/bin/bash

# Load .path and .exports
for file in ~/.{path,exports}; do
    if [[ -r "$file" ]] && [[ -r "$file" ]]; then
        source "$file"
    fi
done
unset file


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH="$HOME/.cargo/bin:$PATH"
