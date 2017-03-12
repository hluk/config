#!/bin/bash
# print usage
if [ $# == 0 ]
then
	echo \
	"Usage: $0 N%[+-]
       $0 5%+   # Volume up 5%
       $0 5%-   # Volume down 5%"
	exit 1
fi

# view changed volume
amixer set Master $1
#amixer set Headphone $1
#amixer set Speaker $1
#amixer set PCM $1

#VOL=`amixer sget Master|sed -n '/^  \(Front\|Mono\)/{s/.*\[\([0-9]\+\)%\].*/\1/p;q}'`

# show osd
#killall -q osd_cat
#osd_cat -c white -O 1 -d 1 -A center -p middle -b percentage -P "$VOL" -T "volume $VOL%" &

