#!/bin/bash
set -xeu

out1="Lenovo Group Limited 0x40BA 0x00000000"
out2="Goldstar Company Ltd LG Ultra HD 0x00003617"
out3="Samsung Electric Company SMBX2231 0x00007345"
out1_enabled=${1:-1}
out3_enabled=${2:-1}
scale=${3:-2}

wallpaper=~/Pictures/wallpapers/current.jpg

script_root="$(dirname "$(readlink -f "$0")")"

s1=$scale
w1=1920
h1=1080

if [[ $out1_enabled == "1" ]]; then
    out1_enabled=enable
else
    out1_enabled=disable
    echo "Disabling $out1"
    w1=0
fi

if [[ $out3_enabled == "1" ]]; then
    out3_enabled=enable
else
    out3_enabled=disable
    echo "Disabling $out3"
    w3=0
fi

s2=$scale
w2=3840
h2=2160

s3=1
w3=1920
h3=1080

x1=$((0))
# In Qt 5.15.2, menu positions are wrong when using multiple displays with
# different Y coordinates.
#y1=$((h2/s2 - h1/s1))
y1=$((0))
x2=$((w1/s1))
y2=$((0))
x3=$((w1/s1 + w2/s2))
y3=$((0))

msg=$(cat <<EOD
output "*" scale $scale

output "$out1" scale $s1
output "$out1" pos $x1 $y1 res ${w1}x$h1
output "$out1" $out1_enabled

output "$out2" scale $s2
output "$out2" pos $x2 $y2 res ${w2}x$h2

output "$out3" scale $s3
output "$out3" pos $x3 $y3 res ${w3}x$h3
output "$out3" $out3_enabled

output "*" bg "$wallpaper" fill
EOD
)
swaymsg "$msg"

# Changing monitors layout can break mako notifications.
"$script_root/notifications.sh" & disown
