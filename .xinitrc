#!/bin/sh
# keyboard
# layout -- it seems that layout needs to be set correctly before lauching
#           xfce4 for shortcuts to work properly
echo ".xinit: setting keyboard"
setxkbmap cz
numlockx &
# autorepeat rate
xset r rate 200 40
# Menu key acts like mouse button -- autorepeat off
xset -r 135

echo ".xinit: starting xbindkeys"
xbindkeys &

# set mouse and touchpad
MOUSE_ID="Genius Ergo Mouse"
TOUCHPAD_ID="ImPS/2 Generic Wheel Mouse"

echo ".xinit: setting mouse speed"
CMD="xinput set-prop '$MOUSE_ID'"
eval $CMD' "Device Accel Constant Deceleration" 2'
#eval $CMD' "Device Accel Adaptive Deceleration" 2'
#eval $CMD' "Device Accel Velocity Scaling" 10'

echo ".xinit: setting touchpad speed"
CMD="xinput set-prop '$TOUCHPAD_ID'"
eval $CMD' "Device Accel Profile" 3'
eval $CMD' "Device Accel Constant Deceleration" 1'
#eval $CMD' "Device Accel Adaptive Deceleration" 1'
eval $CMD' "Device Accel Velocity Scaling" 20'

# cursor
echo ".xinit: setting mouse pointer theme"
( xrdb -merge ~/.Xresources && xsetroot -cursor_name arrow ) &

# wallpaper
echo ".xinit: setting wallpaper"
~/dev/img/set_wallpaper.sh &

# simple web server on port 8080
echo ".xinit: starting webserver on port 8080"
(cd ~/www && python2 -m SimpleHTTPServer 8080 2>&1 >/dev/null) &

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

echo ".xinit: starting window manager"
while :; do ~/wm; done

