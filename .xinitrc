#!/bin/sh
echo ".xinit: starting desktop environment"

# icons in menus (for Qt apps)
gconftool-2 --type boolean --set /desktop/gnome/interface/buttons_have_icons true
gconftool-2 --type boolean --set /desktop/gnome/interface/menus_have_icons true

# pulseaudio for gstreamer
gconftool-2 -t string --set /system/gstreamer/0.10/default/audiosink pulsesink
gconftool-2 -t string --set /system/gstreamer/0.10/default/audiosrc pulsesrc
gconftool-2 -t string --set /system/gstreamer/0.10/default/musicaudiosink pulsesink

# XFCE
exec ck-launch-session startxfce4

# GNOME
#xbindkeys &
#exec ck-launch-session gnome-session

