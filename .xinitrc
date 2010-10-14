#!/bin/sh
# keyboard
# layout -- it seems that layout needs to be set correctly before lauching
#           xfce4 for shortcuts to work properly
setxkbmap cz
numlockx &
# autorepeat rate
xset r rate 200 40
# Menu key acts like mouse button -- autorepeat off
xset -r 135
xbindkeys &

# mouse
xset m 10 1

# cursor
( xrdb -merge ~/.Xresources && xsetroot -cursor_name arrow ) &

# wallpaper
~/dev/img/set_wallpaper.sh &

# simple web server on port 8080
(cd ~/www && python -m SimpleHTTPServer 8080 2>&1 >/dev/null) &

# automatically set LCD color temperature
~/apps/redshift-1.5/src/redshift -l 49.0:16.7 -t 6500:3800 &

# audio
#start-pulseaudio-x11 &

# apps
#(
~/dev/copyq-build/release/copyq &
#~/dev/bin/traycmd.py ~/dev/grooveshark/grooveshark.png ~/dev/grooveshark/grooveshark_toggle.sh &
#pidgin &
#pytyle &
#dropboxd &
#) &

# monitors
#xrandr --output LVDS1 --mode 1366x768                                                                                             
#xrandr --output HDMI1 --right-of LVDS1
#xrandr --output HDMI1 --mode 1920x1080

# panel
tint2 -c ~/.tint2rc &

# window manager
#while ~/wm; do true; done
devilspie 2>&1 >/dev/null &
exec fusion-icon

