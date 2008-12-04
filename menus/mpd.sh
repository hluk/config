#!/bin/sh
MPDACTIONS="
	toggle\n
	next\n
	prev\n
	stop\n
	seek +10\n
	seek -10\n
	random on\n
	random off\n
	shuffle on\n
	shuffle off\n
	update"

MPDACT=`echo -ne $MPDACTIONS |  /home/lukas/dev/menus/menu.sh "MPD:"`

if [ $? -eq 0 ]
then
	mpd
	mpc $MPDACT
fi
