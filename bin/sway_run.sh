#!/bin/bash
# Run an app or command in Sway Wayland compositor.
set -eo pipefail

export QT_QPA_PLATFORM=wayland

# export QT_QPA_PLATFORMTHEME=kvantum
# export QT_STYLE_OVERRIDE=kvantum

export QT_QPA_PLATFORMTHEME=kde
export QT_STYLE_OVERRIDE=kde

export MOZ_ENABLE_WAYLAND=1
export LIBVA_DRIVER_NAME=iHD

#exec rofi -show run
exec ulauncher

# Qt 6 version of krunner does not handle focus properly on Wayland
#export QT_QPA_PLATFORM=xcb
#exec krunner
