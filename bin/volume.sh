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
PERCENT=$(amixer set Master $1 | sed -n '/^  Front Left:/{s/.*\[\([0-9][0-9]*\).*/\1/p;q}')
PERCENT=$(amixer set Front $1 | sed -n '/^  Front Left:/{s/.*\[\([0-9][0-9]*\).*/\1/p;q}')
#COLOR=$(printf '#%02x%02x80\n' $(($PERCENT*255/100)) $((-$PERCENT*255/100+255)))
#killall osd_cat 2> /dev/null
#osd_cat --delay=1 --color=\#66bb44 --shadow=1 --barmode=percentage \
	#--pos=bottom --offset=18 --align=center --percentage=$PERCENT &

