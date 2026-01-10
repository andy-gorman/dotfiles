#!/usr/bin/env bash

# My .bashrc file.

# Don't do anything if we are not running interactively
case $- in
    *i*) ;;
    *) return;;
esac

####################################################
# PATH
####################################################

export PATH="${HOME}/bin:${PATH}"

# Initialize Homebrew (check both Apple Silicon and Intel locations)
for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$brew_path" ]]; then
        eval "$($brew_path shellenv)"
        break
    fi
done
unset brew_path

# bun - JavaScript runtime and package manager
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

####################################################
# Environment variables
####################################################

# vim default editor
export EDITOR=nvim

# Larger bash history (allow 32^3 entries; default is 500)
export HISTSIZE=50000000
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
# Make some commands not show up in history
export HISTIGNORE=" *:ls:cd:cd -:pwd:exit:date:* --help:* -h:pony:pony add *:pony update *:pony save *:pony ls:pony ls *"
# Prefer US English and use UTF-8
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Use bat for syntax-highlighted man pages, fallback to less
if command -v bat &> /dev/null; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
else
    export MANPAGER="less -x"
fi

# Silence the zsh deprecation warning on macOS
export BASH_SILENCE_DEPRECATION_WARNING=1

# Ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Node Options
export NODE_OPTIONS="--max_old_space_size=8192 $NODE_OPTIONS"

####################################################
# Aliases
####################################################

alias be='bundle exec'
alias dcr='docker-compose run --rm'
alias dcu='docker-compose up -d'
alias g='git'
alias gs='git s'

####################################################
# Functions
####################################################

# Copied from https://github.com/wincent/wincent/blob/f7c51dfd808ea78ec10d6501eaa28f0a5b4796e9/roles/dotfiles/files/.zsh/functions
function tmux() {
	# If provided with args, pass them through
	if [[ -n "$*" ]]; then
		command tmux "$@"
		return
	fi

	# Run a .tmux file, if we see one
	# TODO: Probably make this more secure
	if [[ -x .tmux ]]; then
		./.tmux
		return
	fi

	# By default, attach to an existing session or create one, named on the current directory
	SESSION_NAME=$(basename "$(pwd)")
	tmux new -A -s "$SESSION_NAME"
}

####################################################
# Prompt
####################################################

# shellcheck disable=SC1091
if [[ -r "$HOME/.bash_prompt" ]] && [[ -f "$HOME/.bash_prompt" ]]; then
    source "$HOME/.bash_prompt"
fi

####################################################
# Completions
####################################################

# Load bash-completion (includes git, ssh, and many other completions)
# shellcheck disable=SC1091
if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
fi

####################################################
# Shell options 
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

# Let's be normal
set -o emacs

####################################################
# Tool Initialization
####################################################

# Source all tool initialization files from .bashrc.d/
# Files are loaded in alphabetical order: direnv, nodejs, security, themes
if [[ -d "$HOME/.bashrc.d" ]]; then
    for file in "$HOME/.bashrc.d"/*.bash; do
        [[ -r "$file" ]] && source "$file"
    done
    unset file
fi
