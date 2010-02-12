#!/bin/sh
export LIBGL_ALWAYS_SOFTWARE=1

# wallpaper
~/dev/img/set_wallpaper.sh &

# clipboard
~/dev/qt/copyq/build/copyq &

# misc
pidgin &

# keyboard
setxkbmap cz &
xset r rate 200 40 &

# cursor
( xrdb -merge ~/.Xresources && xsetroot -cursor_name arrow ) &

# panel
/home/lukas/apps/tint2/src/tint2 -c ~/.tint2rc &
# conky
conky &

# automatically set LCD color temperature
/home/lukas/apps/redshift-1.0/redshift -l 49.0:16.7 -t 6000:4000 &

# window manager
exec compiz-manager
#exec /home/lukas/apps/tiling/dwm/dwm

