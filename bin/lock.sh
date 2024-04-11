#!/bin/bash
wallpaper=~/Pictures/wallpapers/current.jpg
args=(
    --daemonize
    --indicator-radius=100
    --indicator-thickness=20
    --image="$wallpaper"
)

if [[ $(playerctl status) == Playing ]]; then
    playerctl pause
fi

exec swaylock "${args[@]}"
