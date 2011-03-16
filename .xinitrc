#!/bin/sh

echo ".xinit: setting wallpaper"
~/dev/bin/set_wallpaper.sh &
echo ".xinit: starting redshift"
~/dev/bin/redshift.sh &
echo ".xinit: starting CopyQ"
~/dev/copyq-build/debug/copyq &
echo ".xinit: starting KDE"
export KWIN_DIRECT_GL=1
startkde
exit


# keyboard
# layout -- layout needs to be set correctly for shortcuts to work properly
echo ".xinit: setting keyboard"
setxkbmap -model evdev us
#xmodmap ~/.Xmodmap
numlockx &
# autorepeat rate
xset r rate 200 40
# Menu key acts like mouse button -- autorepeat off
xset -r 135

# set mouse and touchpad
~/mouse.sh &

# cursor
echo ".xinit: setting mouse pointer theme"
( xrdb -merge ~/.Xresources && xsetroot -cursor_name arrow ) &

# wallpaper
echo ".xinit: setting wallpaper"
~/dev/bin/set_wallpaper.sh &

# simple web server on port 8080
#echo ".xinit: starting webserver on port 8080"
#(cd ~/www && python2 -m SimpleHTTPServer 8080 2>&1 >/dev/null) &

# automatically set LCD color temperature
echo ".xinit: starting redshift"
redshift -l 49.0:16.7 -t 6500:3800 -r &

echo ".xinit: starting Wicd"
wicd-client &

echo ".xinit: starting CopyQ"
~/dev/copyq-build/release/copyq &

# monitors
#xrandr --output LVDS1 --mode 1366x768                                                                                             
#xrandr --output HDMI1 --right-of LVDS1
#xrandr --output HDMI1 --mode 1920x1080

# panel
#tint2 -c ~/.tint2rc &

# window manager
#devilspie 2>&1 >/dev/null &

echo ".xinit: starting xbindkeys"
xbindkeys &

echo ".xinit: starting window manager"
while :; do ~/wm; done

