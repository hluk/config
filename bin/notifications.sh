#!/bin/bash
pkill swaync && sleep 0.2 || true
exec /usr/bin/swaync

mako_args=(
    --width=320
    --height=240
    #--border-radius=8
    --font "Roboto 9"
    --margin="4,4,4,4"
    --padding="4,4,4,4"
    #--anchor="top-center"

    #  swaymsg -t get_outputs
    #--output="eDP-1"
    --output="DP-4"

    --actions=1
)

pkill mako || true

exec mako "${mako_args[@]}"
#exec ~/dev/mako/build/mako "${mako_args[@]}"
