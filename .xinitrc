#!/bin/bash
qt_screen_scale_factors='eDP-1=1;DP-2=1;DP-2-1=2;DP-2-2=1;HDMI-2=2;'

fix_dpi() {
    laptop_height=1080

    if lsusb | grep -q Ergonomic; then
        dpi=168
        monitor_height=2160
        nmcli radio wifi off &
        export GDK_SCALE=2
        export GDK_DPI_SCALE=0.5
        xrandr_args="--off"
        export QT_SCREEN_SCALE_FACTORS=
        export QT_SCALE_FACTOR=2
    else
        dpi=96
        monitor_height=1080
        laptop_vertical_pos=$((monitor_height - laptop_height))
        xrandr_args="--pos 0x$laptop_vertical_pos"
        export QT_SCREEN_SCALE_FACTORS="$qt_screen_scale_factors"
        export QT_SCALE_FACTOR=1
    fi

    export QT_AUTO_SCREEN_SCALE_FACTOR=0

    sed -i 's/^Xft\.dpi: .*/Xft.dpi: '"$dpi/" ~/.Xresources
    xrdb -remove
    xrdb -merge ~/.Xresources

    xfconf-query -c xsettings -p /Xft/DPI -s $dpi

    xrandr --output eDP-1 $xrandr_args
}

fix_dpi_kde() {
    export QT_SCREEN_SCALE_FACTORS="$qt_screen_scale_factors"

    sed -i 's/^\(ScreenScaleFactors=\).*/\1'"$qt_screen_scale_factors/" \
        ~/.config/kdeglobals

    sed -i 's/^\(kdeglobals_kscreen_screenscalefactors=\).*/\1'"$qt_screen_scale_factors/" \
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

set_wallpaper() {
    #~/dev/bin/set_wallpaper.sh &
    (sleep 2; feh --bg-fill ~/.cache/lastfm_wallpaper/wallpaper.png) &
}

kde() {
    fix_dpi_kde
    echo 'Starting KDE'
    exec startkde
}

xfce_i3() {
    ~/dev/bin/vsync.sh &
    xfce_settings
    i3 &
    set_wallpaper
    exec startxfce4
}

i3_session() {
    ~/dev/bin/vsync.sh &
    set_wallpaper
    #xfce_settings
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

#xfce_i3
kde
