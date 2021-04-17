#!/bin/bash
mako_args=(
    --width=320
    --height=240
    #--border-radius=8
    --font "Roboto 9"
    --margin="4,4,4,4"
    --padding="4,4,4,4"
    #--anchor="top-center"
)

pkill mako || true

#exec mako "${mako_args[@]}"
exec ~/dev/mako/build/mako "${mako_args[@]}"
