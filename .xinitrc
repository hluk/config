#!/bin/sh
trayer --edge bottom --align right --expand true --tint 0x202020 --alpha 0 --transparent true --height 20 --width 4 &
~/dev/img/set_wallpaper.sh &
~/dev/qt/copyq/build/src/copyq &

xset r 113 r 115 r 116 r rate 250 30 &
( xrdb -merge ~/.Xresources && xsetroot -cursor_name arrow ) &
#xcompmgr -cCfF -D10 -O1 &

exec xmonad

