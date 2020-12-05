#!/bin/bash
set -xeu

out1="Lenovo Group Limited 0x40BA 0x00000000"
out2="Goldstar Company Ltd LG Ultra HD 0x00003617"

s1=2
w1=1920
h1=1080

s2=2
w2=3840
h2=2160

x1=$((0))
y1=$((h2/s2 - h1/s1))
x2=$((w1/s1))
y2=$((0))

msg=$(cat <<EOD
output "$out1" scale $s1
output "$out1" pos $x1 $y1 res ${w1}x$h1

output "$out2" scale $s2
output "$out2" pos $x2 $y2 res ${w2}x$h2

output "*" bg ~/.cache/lastfm_wallpaper/wallpaper.png fill
EOD
)
swaymsg "$msg"
