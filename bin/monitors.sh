#!/bin/bash
set -xeu

out1="Lenovo Group Limited 0x40BA 0x00000000"
out2="Goldstar Company Ltd LG Ultra HD 0x00003617"
out1_enabled=${1:-enable}
scale=${2:-2}

#wallpaper=~/.cache/lastfm_wallpaper/wallpaper.png
wallpaper=~/Documents/wallpapers/i31ntyjb1fl61.jpg

script_root="$(dirname "$(readlink -f "$0")")"

s1=$scale
w1=1920
h1=1080

if [[ $out1_enabled == "disable" ]]; then
    echo "Disabling $out1"
    w1=0
fi

s2=$scale
w2=3840
h2=2160

x1=$((0))
# In Qt 5.15.2, menu positions are wrong when using multiple displays with
# different Y coordinates.
#y1=$((h2/s2 - h1/s1))
y1=$((0))
x2=$((w1/s1))
y2=$((0))

msg=$(cat <<EOD
output "*" scale 1

output "$out1" scale $s1
output "$out1" pos $x1 $y1 res ${w1}x$h1
output "$out1" $out1_enabled

output "$out2" scale $s2
output "$out2" pos $x2 $y2 res ${w2}x$h2

output "*" bg "$wallpaper" fill
EOD
)
swaymsg "$msg"

# Changing monitors layout can break mako notifications.
"$script_root/notifications.sh" & disown
