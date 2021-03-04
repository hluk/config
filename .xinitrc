#!/bin/bash
# Runs chromium-freeworld in new X11 session.
#
# Solves issues with bad resolution in XWayland when scaling is enabled.
#
# Add "allowed_users = anybody" to "/etc/X11/Xwrapper.config" to launch from a
# Wayland session.
. /etc/X11/xinit/xinitrc-common

xrandr --output eDP-1 --off --right-of DP-1-2
xrandr --output DP-1-2 --primary

export LIBVA_DRIVER_NAME=iHD
exec chromium-freeworld \
    --force-device-scale-factor=2 \
    --window-position=0,0
