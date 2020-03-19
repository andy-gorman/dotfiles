#!/bin/bash
# 
# Just reads from .profile and .bashrc, in that order, as decided after reading
# many stackoverflow answers about how dotfiles are sourced, and my files
# are based on that

if [[ -r ~/.profile ]]; then . ~/.profile; fi
case "$-" in *i*) if [[ -r ~/.bashrc ]]; then . ~/.bashrc; fi;; esac
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

export PATH="$HOME/.cargo/bin:$PATH"
export BASH_SILENCE_DEPRECATION_WARNING=1
