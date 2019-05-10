#!/bin/bash
# 
# Just reads from .profile and .bashrc, in that order, as decided after reading
# many stackoverflow answers about how dotfiles are sourced, and my files
# are based on that

if [[ -r ~/.profile ]]; then . ~/.profile; fi
case "$-" in *i*) if [[ -r ~/.bashrc ]]; then . ~/.bashrc; fi;; esac
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/agorman/lib/google-cloud-sdk/path.bash.inc' ]; then . '/Users/agorman/lib/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/agorman/lib/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/agorman/lib/google-cloud-sdk/completion.bash.inc'; fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
