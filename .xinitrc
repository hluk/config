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

# panel
tint2 -c ~/.tint2rc &

# other apps
(
sleep 2;
~/dev/qt/copyq/release/copyq
#~/dev/bin/traycmd.py ~/dev/grooveshark/grooveshark.png ~/dev/grooveshark/grooveshark_toggle.sh &
#pidgin
) &

# window manager
#exec /home/lukas/apps/tiling/dwm/dwm
#exec musca
exec compiz-manager --indirect-rendering

