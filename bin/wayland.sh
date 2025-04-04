#!/bin/bash
set -xeuo pipefail

export KWIN_OPENGL_INTERFACE=egl_wayland
export QT_QPA_PLATFORM=wayland
# export DBUS_SESSION_BUS_ADDRESS=

socket=wayland-1

#Hyprland &
#kwin_wayland &
#mutter --nested &
#gnome-shell --nested &
#sway &
weston &
#weston-launch -- --socket=wayland-1 &

compositor_pid=$!
trap "kill $compositor_pid || true" QUIT TERM INT HUP EXIT

export WAYLAND_DISPLAY=$socket

sleep 2
if [[ $# -gt 0 ]]; then
    "$@"
fi

wait $compositor_pid
