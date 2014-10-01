#!/bin/sh
export DISPLAY=:99
export WAYLAND_DISPLAY=wayland-system-0
export KWIN_OPENGL_INTERFACE=egl_wayland
export QT_QPA_PLATFORM=wayland

weston-launch -- --socket=wayland-system-0 &
Xvfb -screen 0 1366x768x24 :99 &
#startkde-wayland &

sleep 2
echo "----------------------------"
[ "$#" -gt 0 ] && "$@"
