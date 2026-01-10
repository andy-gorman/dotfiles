#!/usr/bin/env bash
# GPG configuration

# Make sure GPG knows where to read input from
GPG_TTY=$(tty)
export GPG_TTY
