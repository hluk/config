#!/bin/bash
# Run an app or command in Sway Wayland compositor.
set -eo pipefail
export QT_QPA_PLATFORMTHEME=qt5ct
export MOZ_ENABLE_WAYLAND=1
exec rofi -show run
