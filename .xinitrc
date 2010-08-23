#!/bin/sh
# keyboard
setxkbmap cz
# autorepeat rate
xset r rate 200 40
# Menu key acts like mouse button -- autorepeat off
xset -r 135
xbindkeys

# mouse
xset m 10 1

# cursor
( xrdb -merge ~/.Xresources && xsetroot -cursor_name arrow ) &

# wallpaper
~/dev/img/set_wallpaper.sh &

# simple web server on port 8080
(cd ~/www && python -m SimpleHTTPServer 8080 1>&2 >/dev/null) &

# automatically set LCD color temperature
#/home/lukas/apps/redshift-1.0/redshift -l 49.0:16.7 -t 6000:4000 &

# audio
start-pulseaudio-x11 &

# apps
#(
~/dev/copyq/release/copyq &
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
(sleep 2; tint2 -c ~/.tint2rc) &

# window manager
while ~/wm; do true; done

