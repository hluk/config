#!/bin/bash
if [[ -f uv.lock || -f .venv/pyvenv.cfg ]]; then
    cmd="uv run"
elif [[ -f poetry.lock ]]; then
    cmd="poetry run"
fi

#exec $cmd hx "$@"
exec $cmd nvim "$@"
#exec $cmd zed --foreground "$@"
#exec $cmd ~/.local/bin/lvim "$@"
