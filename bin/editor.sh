#!/bin/bash
if [[ -f poetry.lock ]]; then
    cmd="poetry run"
fi

#exec $cmd hx "$@"
exec $cmd nvim "$@"
#exec $cmd zed --foreground "$@"
#exec $cmd ~/.local/bin/lvim "$@"
