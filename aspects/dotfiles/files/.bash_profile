#!/usr/bin/env bash
# 
# Sources bashrc. That sources the rest of the stuff I care about

if [[ -r "${HOME}/.bashrc" ]]; then 
		# shellcheck disable=SC1091
    . "${HOME}/.bashrc";
fi
