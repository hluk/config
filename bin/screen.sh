#!/bin/bash
set -e
cd ~
export TMUX=""
if tmux list-sessions > /dev/null; then
    tmux attach -d
else
    exec tmux -2
fi
