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

export PATH="${HOME}/bin:${HOME}/Library/Python/3.8/bin:${PATH}":${GOPATH}/bin
eval "$(/opt/homebrew/bin/brew shellenv)"

####################################################
# Environment variables
####################################################

# vim default editor
export EDITOR=/opt/homebrew/bin/nvim

# Larger bash history (allow 32^3 entries; default is 500)
export HISTSIZE=50000000;
export HISTFILESIZE=$HISTSIZE;
export HISTCONTROL=ignoredups;
# Make some commands not show up in history
export HISTIGNORE=" *:ls:cd:cd -:pwd:exit:date:* --help:* -h:pony:pony add *:pony update *:pony save *:pony ls:pony ls *";
# Prefer US Engilsh and use UTF-8 export LANG="en_US.UTF-8";
export LC_ALL="en_US.UTF-8";

# Don't clear the screen after quitting a manual page
export MANPAGE="less -x";

# Git Duet
export GIT_DUET_CO_AUTHORED_BY=1
export GIT_DUET_GLOBAL=true

# Stuff for go
export GOPATH=/usr/local/go/bin

# Silence the zsh warning on os x
export BASH_SILENCE_DEPRECATION_WARNING=1

# I think Husky is annnoying!
export HUSKY=0
#
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
	if [ -x .tmux ]; then
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

# shellcheck disable=SC1091
source "$HOME/.git-completion.bash"

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

# Tinted Shell
export TINTED_SHELL_ENABLE_BASE24_VARS=1
# shellcheck disable=SC1091
source "$HOME/.config/base16-shell/scripts/base16-nord.sh"


## NVM
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
# shellcheck disable=SC1091
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

GPG_TTY=$(tty) # Make sure GPG knows where to read input from
export GPG_TTY

export VOLTA_FEATURE_PNPM=1

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

eval "$(direnv hook bash)"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
