#!/usr/bin/env bash
# Author: Andy Gorman

set -e

if tmux has-session -t=dot 2> /dev/null; then
	tmux attach -t dot
	exit
fi

tmux new-session -d -s dot -n project -c "."

tmux new-window -t dot: -n vim -a -c "aspects/nvim/.config/nvim"
tmux split-window -t dot:vim -h -c "#{pane_current_path}" -p 50
tmux send-keys -t dot:vim.left "nvim" Enter
tmux send-keys -t dot:vim.right "git s" Enter

tmux new-window -t dot: -n dot -a -c "aspects/dotfiles"
tmux split-window -t dot:dot -h -c "#{pane_current_path}" -p 50
tmux send-keys -t dot:dot.left "nvim" Enter

tmux attach -t dot:project.right

