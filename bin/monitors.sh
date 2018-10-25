#!/bin/bash
set -xeuo pipefail

monitor1=HDMI-2
monitor2=eDP-1

args_init=(
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
