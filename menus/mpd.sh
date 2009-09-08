#!/bin/bash
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


	# library and playlists
	ACTS="$ACTS
`listAll | sed 's/^/>/'`
`mpc lsplaylists | sed 's/^/+/'`"

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
		test -n "$ARG" && LABEL="JAMENDO($ARG):" || LABEL="JAMENDO:"
		ARG2=`(echo; sed -n 's/^/-b /p' <<< "\"$CLIP\""; cat "$MENUDIR/jamendo.lst") | "$MENU" "$LABEL"` &&
		if [ -n "$ARG2" ]
		then
			ARG="$ARG $ARG2"
			ARG="$ARG" $0 jamendo
		elif [ -n "$ARG" ]
		then
			eval "~/dev/wget/jamendo/jamendo.sh $ARG > ~/Playlists/jamendo.m3u"
			mpc clear && mpc load jamendo && mpc play
		fi
		;;

		"list")
		ARG=`mpc playlist | "$MENU" "LIST:"` &&
		test -n "$ARG" && mpc play "$ARG"
		;;

		#"play")
		#ARG=`listAll | "$MENU" "PLAY:"`
		#test -n "$ARG" && mpc clear && mpc add "$ARG" && mpc play
		#;;

		"playall")
		mpc clear && mpc add / && mpc consume on && mpc play;
		;;

		"+"*)
		ITEM="`sed 's/^+//' <<< "$ACT"`"
		mpc clear && mpc load "$ITEM" && mpc play
		;;

		">"*)
		ITEM="`sed 's/^>//' <<< "$ACT"`"
		if grep -e '+$' <<< "$ACT"
		then
			mpc add "`sed 's/+$//' <<< "$ITEM"`"
		else
			mpc clear && mpc add "$ITEM" &&	mpc play
		fi
		;;

		*)
		mpc $ACT
		;;
	esac
fi


