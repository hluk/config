#!/bin/bash
fix_dpi() {
    if lsusb | grep -q Ergonomic; then
        dpi=168
    else
        dpi=96
    fi

    export QT_SCALE_FACTOR=1
    export QT_AUTO_SCREEN_SCALE_FACTOR=0
    export QT_SCREEN_SCALE_FACTORS='eDP-1=1;DP-2=1;DP-2-1=1;DP-2-2=1;HDMI-2=2;'

    sed -i 's/^Xft\.dpi: .*/Xft.dpi: '"$dpi/" ~/.Xresources
    xrdb -merge ~/.Xresources

    xfconf-query -c xsettings -p /Xft/DPI -s $dpi
}

fix_dpi_kde() {
    sed -i 's/^\(ScreenScaleFactors=\).*/\1'"$QT_SCREEN_SCALE_FACTORS/" \
        ~/.config/kdeglobals
    sed -i 's/^\(kdeglobals_kscreen_screenscalefactors=\).*/\1'"$QT_SCREEN_SCALE_FACTORS/" \
        ~/.config/startupconfig
}

xfce_settings() {
    xfsettingsd
    sleep 1
    fix_dpi
}

kde() {
    fix_dpi_kde
    exec startkde
}

xfce_i3() {
    ~/dev/bin/vsync.sh &
    ~/dev/bin/set_wallpaper.sh &
    xfce_settings
    i3 &
    exec startxfce4
}

i3_session() {
    ~/dev/bin/vsync.sh &
    xfce_settings
    exec i3
}

xfce_openbox() {
    fix_dpi
    ~/dev/bin/vsync.sh &
    openbox &
    exec startxfce4
}

. /etc/X11/xinit/xinitrc-common

xfce_i3
