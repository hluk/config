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

# clipboard
~/dev/qt/copyq/release/copyq &

(
# conky
#conky 2> /dev/null &

# wait for time sync (ntp)
sleep 2

# panel
tint2 -c ~/.tint2rc &

# wait for window manger (to handle correctly new windows)
sleep 2

# pidgin
pidgin &
) &

# automatically set LCD color temperature
#/home/lukas/apps/redshift-1.0/redshift -l 49.0:16.7 -t 6000:4000 &

# window manager
#exec /home/lukas/apps/tiling/dwm/dwm
#exec musca
exec compiz-manager
#exec fusion-icon

