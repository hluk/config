#!/bin/sh
trayer --edge bottom --align right --expand true --tint 0x151515 --alpha 0 --transparent true --height 20 --width 5 &
~/dev/img/set_wallpaper.sh &
~/apps/easystroke/easystroke &
parcellite &

xset r 113 r 115 r 116 r rate 250 30 &
xsetroot -cursor_name arrow &
#xcompmgr -cCfF -D10 -O1 &

exec xmonad

