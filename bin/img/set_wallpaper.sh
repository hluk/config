#!/bin/sh
# vim: foldmarker=<<<,>>>
# usage:
#   ./set_wallpaper.sh # sets random wallpaper from WALLPATH env
#   ./set_wallpaper.sh image_file
WALLPATH=${WALLPATH:-"$HOME/wallpapers"}
TMPPATH="$WALLPATH/_tmp"
TMP="/home/lukas/dev/img/wallpaper.tmp.jpg"

# redirect output to LOGFILE
test -n "$LOGFILE" && exec 1>>"$LOGFILE"

trap 'echo "}}} FAILED!"; exit 1' TERM QUIT INT

# take image as parameter or random image from WALLPATH
if [ -n "$1" ]
then
	echo "`date -R`: Setting wallpaper \"$1\" {{{"
	/usr/bin/curl -s -o "$TMP" "$1" && IMG="$TMP" || IMG="$1"
else 
	IMG="$WALLPATH/`cd $WALLPATH && /bin/ls -1 | sort -R | head -1`" || exit $?
	echo "`date -R`: Setting random wallpaper \"$IMG\" {{{"
fi

echo -e "\tInput: `/usr/bin/identify "$IMG"`"

# get screen resolution
RES=(`xdpyinfo|sed -n '/^  dimensions:    /{s/.* \([0-9]\+\)x\([0-9]\+\).*/\1 \2/;p;q}'`)

# if wallpaper already exists
WALL="$TMPPATH/`basename "$IMG"_${RES[0]}x${RES[1]}`.png"
if [ ! -f "$WALL" ]
then
	echo -e "\tResizing..."
	SIZE=(`/usr/bin/identify -format "%w %h" "$IMG"`)
	X=$((SIZE[0]*RES[1]))
	Y=$((SIZE[1]*RES[0]))

	# calc wallpaper size
	test $X -ge $Y &&
	W=$((X/SIZE[1])) H=${RES[1]} ||
	W=${RES[0]}      H=$((Y/SIZE[0]))

	# create wallpaper
	mkdir -p "$TMPPATH" &&
	convert "$IMG" -resize ${W}x${H} "$WALL"
fi &&
echo -e "\tOutput: `/usr/bin/identify "$WALL"`" &&
echo -e "\tSetting..." &&
/usr/bin/feh --bg-center "$WALL" &&
echo "}}} Done" || exit 1

# clean
rm -rf "$TMP"

