#!/usr/bin/env bash
# 
# Sources bashrc. That sources the rest of the stuff I care about

if [[ -r "${HOME}/.bashrc" ]]; then 
		# shellcheck source=.bashrc
    . ~/.bashrc;
fi
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
