#!/bin/sh
SONG=$(mpc playlist | /home/lukas/dev/menus/menu.sh "PLAY:")

if [ $? -eq 0 ]
then
	mpc play $(echo $SONG | sed 's/).*$//')
fi

