#!/bin/bash
if lsusb | grep -q Ergonomic; then
    export SCALE=2
else
    export SCALE=1
fi

export QT_SCALE_FACTOR=1
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCREEN_SCALE_FACTORS='eDP-1=1;DP-2=1;DP-2-1=1;DP-2-2=1;HDMI-2=2;'
export GDK_SCALE=$SCALE

for dpi in 96/DP-1 96/DP-2 168/HDMI-2; do
    for suffix in "" -1 -2; do
        xrandr --dpi "$dpi$suffix" || exit 1
    done
done

sed -i 's/^\(ScreenScaleFactors=\).*/\1'"$QT_SCREEN_SCALE_FACTORS/" \
    ~/.config/kdeglobals
sed -i 's/^\(kdeglobals_kscreen_screenscalefactors=\).*/\1'"$QT_SCREEN_SCALE_FACTORS/" \
    ~/.config/startupconfig

#gsettings set org.gnome.desktop.interface text-scaling-factor $SCALE
gsettings set org.gnome.desktop.interface scaling-factor $SCALE

. /etc/X11/xinit/xinitrc-common

exec startkde
#exec startxfce4
