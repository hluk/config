#!/bin/bash
set -xeuo pipefail

source ~/.config/monitors
#monitor1=HDMI2
#monitor2=eDP1
#monitor1_dpi=168
#monitor2_dpi=96

args_init=(
    --dpi "$monitor2_dpi/$monitor2"
    --dpi "$monitor1_dpi/$monitor1"

    --output "$monitor1"
    --panning 0x0 --primary
)

args_off=(
    --output "$monitor2"
    --off
)

args_on=(
    --output "$monitor2"
    --auto
    --left-of "$monitor1"
)

for arg in "$@"; do
    args=args_$arg[@]
    xrandr "${!args}"
done

~/dev/bin/set_wallpaper.sh || xsetroot -solid "#000000"
