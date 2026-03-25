#!/usr/bin/env bash
# zellij - wrapper function for project-specific layouts

function zellij() {
	# If provided with args, pass them through
	if [[ -n "$*" ]]; then
		command zellij "$@"
		return
	fi

	# Session name based on current directory
	SESSION_NAME=$(basename "$(pwd)")

	# Check if session already exists and attach if it does
	if command zellij list-sessions 2>/dev/null | grep -q "^${SESSION_NAME}$"; then
		command zellij attach "$SESSION_NAME"
		return
	fi

	# If a layout file exists, use it to create new session
	if [ -f .zellij-layout.kdl ]; then
		command zellij --session "$SESSION_NAME" --layout .zellij-layout.kdl
		return
	fi

	# By default, create a new session
	command zellij --session "$SESSION_NAME"
}
