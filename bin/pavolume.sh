#!/bin/bash
VOL=`amixer sget Master|sed -n '/^  Front/{s/.*Playback \([0-9]\+\).*/\1/p;q}'`
VOL=$((VOL+$1))

pactl set-sink-volume 0 -- "$VOL"
pactl set-sink-volume 1 -- "$VOL"

# show osd
killall -q osd_cat
P=$((VOL*100/65536))
osd_cat -c white -O 1 -d 1 -A center -p middle -b percentage -P "$P" -T "volume $P%" &

