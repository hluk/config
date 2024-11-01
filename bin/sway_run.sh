#!/bin/bash
# Run an app or command in Sway Wayland compositor.
set -eo pipefail

export QT_QPA_PLATFORMTHEME=kde
export QT_STYLE_OVERRIDE=kde

ulauncher-toggle

# Qt 6 version of krunner does not handle focus properly on Wayland
# export QT_QPA_PLATFORM=xcb
# exec krunner
