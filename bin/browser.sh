#!/bin/bash
# Fix high-DPI rendering on Wayland.
#export GDK_BACKEND=wayland
#export CLUTTER_BACKEND=wayland
#export SDL_VIDEODRIVER=wayland

exec firefox "$@" &>/dev/null
