#!/bin/sh
MENUDIR="/home/lukas/dev/menus/"
MENU="$MENUDIR/menu.sh"

function listAll () { #{{{
	awk -F ': ' '
	$1 == "begin" {print $2;}
	$1 == "filename" {print dir"/"$2;}
	' ~/.mpd/db
} #}}}

INFO=`mpc`
RND=`sed -n 's/.*random: \([^ ]*\).*/\1/p' <<< "$INFO"`
SINGLE=`sed -n 's/.*single: \([^ ]*\).*/\1/p' <<< "$INFO"`
CONSUME=`sed -n 's/.*consume: \([^ ]*\).*/\1/p' <<< "$INFO"`

if [ $# -ne 0 ]
then
	ACT="$@"
else
# actions#{{{
ACTS="\
add
clear
consume:$CONSUME
jamendo
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
update" #}}}

	# url from clipboard
	CLIP=`xclip -o | grep -e '^\(http\|file\|mms\)://'` &&
	ACTS=">$CLIP
	$ACTS"

	ACT=`"$MENU" "MPD:" <<< "$ACTS" | sed 's/:\(on\|off\)//'`
fi

if [ $? -eq 0 ]
then
	pidof mpd > /dev/null || mpd
	case "$ACT" in
		"add")
		ARG=`(for X in $(mpc ls); do mpc ls $X; done; mpc listall) | "$MENU" "ADD:"` &&
		test -n "$ARG" && mpc add "$ARG"
		;;
		"jamendo")
		ARG=`(test "$ORDER" || echo -e "ORDER=random\nORDER=rating_desc"; cat "$MENUDIR/jamendo.lst") | "$MENU" "JAMENDO(order=$ORDER):"` &&
		if echo "$ARG" | grep -q '^ORDER='
		then
			eval "$ARG $0 jamendo"
		else
			test -n "$ARG" && (
				eval "$ARG ~/dev/wget/jamendo/jamendo.sh > ~/Playlists/jamendo.m3u"
				mpc clear && mpc load jamendo && mpc play
			)
		fi
		;;
		"list")
		ARG=`mpc playlist | "$MENU" "LIST:"` &&
		test -n "$ARG" && mpc play "$ARG"
		;;
		"playlists")
		ARG=`mpc lsplaylists | "$MENU" "PLAYLISTS:"` &&
		test -n "$ARG" && mpc clear && mpc load "$ARG" && mpc play
		;;
		"play")
		ARG=`listAll | "$MENU" "PLAY:"`
		test -n "$ARG" && mpc clear && mpc add "$ARG" && mpc play
		;;
		"playall")
		mpc clear && mpc add / && mpc consume on && mpc play;
		;;
		">"*)
		mpc clear && \
		mpc add "`sed 's/^>//' <<< "$ACT"`" && \
		mpc play
		;;
		*)
		mpc $ACT
		;;
	esac
fi


