#!/bin/sh
if pgrep pulseaudio 2>/dev/null; then
    pactl set-sink-mute alsa_output.pci-0000_00_1b.0.analog-stereo false
else
    amixer get Master | grep -q '\[on\]' &&
        amixer set Master mute ||
        amixer set Master unmute
fi

