#!/bin/bash
# script argument is number
#  - positive/negative to raise/lower the backlight brightness
test $# -eq 1 || exit 1

# already running?
pidof -o $$ -sx backlight.sh 2>&1 >/dev/null && exit 1

# get current backlight value
N=0x`sudo setpci -s 00:02.0 F4.B`

# calculate new value
N=$((N+$1))
if [ $N -gt 255 ]
then
    N=255
elif [ $N -lt 0 ]
then
    N=0
fi

# set new brightness
sudo setpci -s 00:02.0 F4.B=`printf '%x' $N`

echo $N

