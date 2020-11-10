#!/bin/bash
mako_args=(
    --width=320
    --height=640
    --border-radius=8
)
exec mako "${mako_args[@]}"
