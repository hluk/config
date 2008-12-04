#!/bin/sh
# playlist won't be cleared if there is SPACE at the end of selection
SONGNAME=`(echo .; awk -F": " '
$1=="file" { print $2; next }
$1=="begin" { print $2"/"; next }
' $HOME/.mpd/database) | \
	/home/lukas/dev/menus/menu.sh "PLAY:"`

if [ $? -eq 0 ]
then
	echo "$SONGNAME" | egrep -q ' $'
	if [ $? -ne 0 ]
	then
		# no space at end -> clear list
		mpd
		mpc load default
		mpc clear
	else
		SONGNAME=`echo "$SONGNAME" | sed 's/[ ]*$//'`
	fi

	mpc search filename "$SONGNAME" | mpc add
	mpc play
fi

