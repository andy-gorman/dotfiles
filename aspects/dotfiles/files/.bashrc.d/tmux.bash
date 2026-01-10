#!/usr/bin/env bash
# tmux - wrapper function with TOFU security for .tmux files

# Copied from https://github.com/wincent/wincent/blob/f7c51dfd808ea78ec10d6501eaa28f0a5b4796e9/roles/dotfiles/files/.zsh/functions
function tmux() {
	# If provided with args, pass them through
	if [[ -n "$*" ]]; then
		command tmux "$@"
		return
	fi

  if [ -x .tmux ]; then
    # Prompt the first time we see a given .tmux file before running it.
    local DIGEST
		DIGEST="$(openssl sha512 .tmux)"
		if [[ -z "$DIGEST" ]]; then
			echo "Error: Unable to compute digest. openssl not found?" >&2
			return 1
		fi

    if ! grep -q "$DIGEST" ~/.tmux.digests 2> /dev/null; then
      cat .tmux
      read -n 1 -r \
        'REPLY?Trust (and run) this .tmux file? (t = trust, otherwise = skip) '
      echo
      if [[ $REPLY =~ ^[Tt]$ ]]; then
        echo "$DIGEST" >> ~/.tmux.digests
        ./.tmux
        return
      fi
    else
      ./.tmux
      return
    fi
  fi

	# By default, attach to an existing session or create one, named on the current directory
	SESSION_NAME=$(basename "$(pwd)")
	tmux new -A -s "$SESSION_NAME"
}
