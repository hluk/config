#!/bin/bash
if [[ -f poetry.lock ]]; then
    export PATH="$HOME/.local/bin:$PATH"
    cmd="poetry run"
fi

#exec $cmd hx "$@"
exec $cmd nvim "$@"
#exec $cmd zed --foreground "$@"
#exec $cmd ~/.local/bin/lvim "$@"
