#!/bin/bash
set -xeuo pipefail

export KWIN_OPENGL_INTERFACE=egl_wayland
export QT_QPA_PLATFORM=wayland

if [[ -n $DISPLAY ]]; then
    #weston &
    #kwin_wayland &
    sway &
else
    weston-launch -- --socket=wayland-system-0 &
fi

sleep 2
if [[ $# -gt 0 ]]; then
    "$@"
fi
wait
