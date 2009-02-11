#!/bin/bash

TEXT=$(mocp -Q '<span color="#ffff99" font_desc="14">%artist</span>   %song')

echo "naughty.notify({ text = '$TEXT', icon=\"/usr/share/icons/gnome/48x48/apps/gnome-audio.png\", icon_size=48 })" | awesome-client

