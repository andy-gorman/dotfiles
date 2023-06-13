#!/usr/bin/env bash
# 
# My .bashrc file. 

# Don't do anything if we are not running interactively
case $- in
    *i*) ;;
    *) return;;
esac
# Load 
for file in ~/.{bash_prompt,aliases,auto-completions,exports,projectrc,path}; do
    if [[ -r "$file" ]] && [[ -f "$file" ]]; then
        source "$file"
    fi
done
unset file

####################################################
# Shell options. Maybe split into own file?
####################################################

# Check the window size after each command and, if necessary, update 
# the values of LINES and COLUMNS.
shopt -s checkwinsize

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# `**/qux` will enter `./foo/bar/baz/qux`
shopt -s autocd

# Recursive globbing, e.g. `echo **/*.txt`
shopt -s globstar

# Add tab completion for SSH hostnames based on ~/.ssh/config
# ignoring wildcards
[[ -e "$HOME/.ssh/config" ]] && complete -o "default" \
    -o "nospace" \
    -W "$(grep "^Host" ~/.ssh/config | \
    grep -v "[?*]" | cut -d " " -f2 | \
    tr ' ' '\n')" scp sftp ssh

# Make less more friendly for non-text input files, see lesspipe(1)
export LESSOPEN="|/usr/local/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1

# Let's be normal
set -o emacs

# Dark Terminal themes
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# . /usr/local/opt/asdf/asdf.sh

# . /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash


## NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# Created by `pipx` on 2022-01-18 18:47:07
export PATH="$PATH:/Users/andrewgorman/.local/bin"
