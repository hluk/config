#!/bin/bash
# Pause music if screen is lock.
# See: https://blog.holms.place/2022/11/08/pausing-resuming-media-playback-on-lock-under-gnome.html
# Add desktop file ~/.config/systemd/user/pause-media-when-lockscreen.service:
#
#   [Unit]
#   Description=Pause all media when screen is locked
#   After=graphical.target
#
#   [Service]
#   Type=simple
#   ExecStart=%h/bin/pause-media-when-lockscreen.sh
#   Restart=on-abort
#
#   [Install]
#   WantedBy=default.target
#
# Install:
#
#   systemctl enable --now --user pause-media-when-lockscreen
#
set -euo pipefail

/usr/bin/dbus-monitor --session "type='signal',interface='org.gnome.ScreenSaver'" |
    while read x; do
        case "$x" in
            *"boolean true"*)
                # Lock and unlock signal are getting sent twice for some reason. So be sure that we test only once.
                playerctl pause --all-players & disown
        esac
    done

