#!/bin/bash
VOL=`amixer sget Master|sed -n '/^  \(Front\|Mono: \)/{s/.*Playback \([0-9]\+\).*/\1/p;q}'`
[ -n "$1" ] && VOL=$((VOL+$1))

pactl set-sink-volume 0 -- "$VOL" 2>/dev/null
pactl set-sink-volume 1 -- "$VOL" 2>/dev/null

# show osd
killall -q osd_cat
percent=$((VOL*100/65536))
osd_cat -c white -O 1 -d 1 -A center -p middle -b percentage -P "$percent" -T "volume $percent%" &

