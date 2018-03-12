#!/bin/bash

# Load .path and .exports
for file in ~/.{path,exports}; do
    if [[ -r "$file" ]] && [[ -r "$file" ]]; then
        source "$file"
    fi
done
unset file

