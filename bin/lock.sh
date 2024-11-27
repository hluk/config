#!/bin/bash
# wallpaper=~/Pictures/wallpapers/current.jpg
# args=(
#     --daemonize
#     --indicator-radius=100
#     --indicator-thickness=20
#     --image="$wallpaper"
#     # --color=000000
# )

playerctl pause --all-players & disown

# exec swaylock "${args[@]}"
hyprlock --immediate --immediate-render & sleep 1
