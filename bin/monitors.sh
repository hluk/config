#!/bin/bash
set -xeu

out1="BOE 0x086E Unknown"
out2="LG Electronics LG Ultra HD 0x00003617"
out1_enabled=${1:-1}
scale1=1.5
scale2=2
scale=2

wallpaper=~/Pictures/wallpapers/current.jpg

script_root="$(dirname "$(readlink -f "$0")")"

s1=$scale1
w1=1920
h1=1080

if [[ $out1_enabled != "1" ]]; then
    echo "Disabling $out1"
    w1=0
fi

s2=$scale2
w2=3840
h2=2160

x1=$((0))
# In Qt 5.15.2, menu positions are wrong when using multiple displays with
# different Y coordinates.
#y1=$((h2/s2 - h1/s1))
y1=$((0))
x2=$(python -c "print(int($w1/$s1))")
y2=$((0))

if [[ $out1_enabled == "1" ]]; then
msg_out1=$(cat <<EOD
output "$out1" scale $s1
output "$out1" pos $x1 $y1 res ${w1}x$h1
output "$out1" enable
EOD
)
else
msg_out1=$(cat <<EOD
output "$out1" disable
EOD
)
fi

msg=$(cat <<EOD
output "*" scale $scale

$msg_out1

output "$out2" scale $s2
output "$out2" pos $x2 $y2 res ${w2}x$h2

output "*" bg "$wallpaper" fill
EOD
)
echo $msg
exit
swaymsg "$msg"

# Changing monitors layout can break mako notifications.
"$script_root/notifications.sh" & disown
