#!/bin/sh
function listAll {
	awk -F ': ' '
	$1 == "begin" {print $2;}
	$1 == "filename" {print dir"/"$2;}
	' ~/.mpd/db
}

INFO=`mpc`
RND=`sed -n 's/.*random: \([^ ]*\).*/\1/p' <<< "$INFO"`
SINGLE=`sed -n 's/.*single: \([^ ]*\).*/\1/p' <<< "$INFO"`
CONSUME=`sed -n 's/.*consume: \([^ ]*\).*/\1/p' <<< "$INFO"`
# actions
ACTS="\
add
clear
consume:$CONSUME
list
next
playlists
play
playall
prev
random:$RND
seek +10
seek -10
shuffle
single:$SINGLE
stop
toggle
update"

# url from clipboard
CLIP=`xclip -o | grep -e '^\(http\|file\|mms\)://'` &&
ACTS=">$CLIP
$ACTS"

ACT=`/home/lukas/dev/menus/menu.sh "MPD:" <<< "$ACTS" | sed 's/:\(on\|off\)//'`

if [ $? -eq 0 ]
then
	pidof mpd > /dev/null || mpd
	case "$ACT" in
		"add")
		ARG=`(for X in $(mpc ls); do mpc ls $X; done; mpc listall) | /home/lukas/dev/menus/menu.sh "ADD:"` &&
		test -n "$ARG" && mpc add "$ARG"
		;;
		"list")
		ARG=`mpc playlist | /home/lukas/dev/menus/menu.sh "LIST:"` &&
		test -n "$ARG" && mpc play "$ARG"
		;;
		"playlists")
		ARG=`mpc lsplaylists | /home/lukas/dev/menus/menu.sh "PLAYLISTS:"` &&
		test -n "$ARG" && mpc clear && mpc load "$ARG" && mpc play
		;;
		"play")
		ARG=`listAll | /home/lukas/dev/menus/menu.sh "PLAY:"`
		test -n "$ARG" && mpc clear && mpc add "$ARG" && mpc play
		;;
		"playall")
		mpc clear; mpc add /; mpc random on; mpc consume on; mpc play;
		;;
		">"*)
		mpc clear
		mpc add "`sed 's/^>//' <<< "$ACT"`"
		mpc play
		;;
		*)
		mpc $ACT
		;;
	esac
fi


