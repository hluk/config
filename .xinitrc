#!/bin/bash
fix_dpi() {
    export QT_SCALE_FACTOR=1
    export QT_AUTO_SCREEN_SCALE_FACTOR=0
    export QT_SCREEN_SCALE_FACTORS='eDP-1=1;DP-2=1;DP-2-1=1;DP-2-2=1;HDMI-2=2;'

    for dpi in 96/DP-1 96/DP-2 168/HDMI-2; do
        for suffix in "" -1 -2; do
            xrandr --dpi "$dpi$suffix" || exit 1
        done
    done
}

fix_dpi_kde() {
    sed -i 's/^\(ScreenScaleFactors=\).*/\1'"$QT_SCREEN_SCALE_FACTORS/" \
        ~/.config/kdeglobals
    sed -i 's/^\(kdeglobals_kscreen_screenscalefactors=\).*/\1'"$QT_SCREEN_SCALE_FACTORS/" \
        ~/.config/startupconfig
}

fix_dpi_gtk() {
    if lsusb | grep -q Ergonomic; then
        export GDK_SCALE=2
    else
        export GDK_SCALE=1
    fi

    #gsettings set org.gnome.desktop.interface text-scaling-factor $GDK_SCALE
    gsettings set org.gnome.desktop.interface scaling-factor $GDK_SCALE
}

kde() {
    fix_dpi
    fix_dpi_kde
    exec startkde
}

dwm() {
    ~/dev/bin/vsync.sh &
    exec ~/dev/dwm/dwm
}

xfce_i3() {
    fix_dpi
    xfsettingsd
    i3 &
    exec startxfce4
}

i3_session() {
    fix_dpi
    xfsettingsd
    exec i3
}

xfce_openbox() {
    ~/dev/bin/vsync.sh &
    openbox &
    exec startxfce4
}

openbox() {
    ~/dev/bin/vsync.sh &
    exec openbox-kde-session
}

. /etc/X11/xinit/xinitrc-common

i3_session
