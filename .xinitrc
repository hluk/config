#!/bin/bash
fix_dpi() {
    laptop_height=1080

    if lsusb | grep -q Ergonomic; then
        dpi=168
        monitor_height=2160
        font_size=9
        nmcli radio wifi off &
        export GDK_SCALE=2
        export GDK_DPI_SCALE=0.5
    else
        dpi=96
        monitor_height=1080
        font_size=15
    fi

    export QT_SCALE_FACTOR=1
    export QT_AUTO_SCREEN_SCALE_FACTOR=0
    export QT_SCREEN_SCALE_FACTORS='eDP-1=1;DP-2=1;DP-2-1=1;DP-2-2=1;HDMI-2=2;'

    sed -i 's/^Xft\.dpi: .*/Xft.dpi: '"$dpi/" ~/.Xresources
    xrdb -merge ~/.Xresources

    xfconf-query -c xsettings -p /Xft/DPI -s $dpi

    laptop_vertical_pos=$((monitor_height - laptop_height))
    xrandr --output eDP-1 --pos 0x$laptop_vertical_pos

    sed -i 's/^\(text_font.*\) [0-9]\+/\1 '"$font_size"'/' ~/.config/hexchat/hexchat.conf
}

fix_dpi_kde() {
    sed -i 's/^\(ScreenScaleFactors=\).*/\1'"$QT_SCREEN_SCALE_FACTORS/" \
        ~/.config/kdeglobals
    sed -i 's/^\(kdeglobals_kscreen_screenscalefactors=\).*/\1'"$QT_SCREEN_SCALE_FACTORS/" \
        ~/.config/startupconfig
}

xfce_settings() {
    fix_dpi
    xfsettingsd
    sleep 1
    fix_dpi
    xfconf-query \
        --channel xfce4-session --property /general/LockCommand \
        --create --type string --set 'i3lock --color=000000'
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

export QT_QPA_PLATFORMTHEME=qt5ct

xfce_i3
