#!/bin/bash
wallpaper=~/Pictures/wallpapers/current.jpg
args=(
    --daemonize
    --indicator-radius=100
    --indicator-thickness=20
    --image="$wallpaper"
)
exec swaylock "${args[@]}"
