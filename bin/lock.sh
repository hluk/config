#!/bin/bash
wallpaper=~/Pictures/wallpapers/current.jpg
args=(
    --daemonize
    --indicator-radius=100
    --indicator-thickness=20
    --image="$wallpaper"
)

playerctl pause --all-players & disown

exec swaylock "${args[@]}"
#hyprlock & sleep 1
