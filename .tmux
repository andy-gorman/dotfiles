#!/usr/bin/env bash
# Author: Andy Gorman

set -e

if tmux has-session -t=dot 2> /dev/null; then
	tmux attach -t dot
	exit
fi

tmux new-session -d -s dot -n vim -x "$(tput cols)" -y "$(tput lines)" -c "aspects/nvim/.config/nvim"

tmux split-window -t dot:vim -h -c "#{pane_current_path}" -p 40

tmux send-keys -t dot:vim.left "vim" Enter
tmux send-keys -t dot:vim.right "git s" Enter

tmux attach -t dot:vim.right
