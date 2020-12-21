#!/bin/bash
# Run an app or command in Sway Wayland compositor.
set -eo pipefail
export QT_QPA_PLATFORMTHEME=kvantum
export QT_STYLE_OVERRIDE=kvantum
export MOZ_ENABLE_WAYLAND=1
export LIBVA_DRIVER_NAME=iHD
exec rofi -show run
