#!/bin/bash
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
RES=(`xdpyinfo|sed -n '/^  dimensions:    /{s/.* \([0-9]\+\)x\([0-9]\+\).*/\1 \2/;p;q}'`) || exit $?

# if wallpaper already exists
WALL="$TMPPATH/`basename "$IMG"_${RES[0]}x${RES[1]}`.png"
if [ ! -f "$WALL" ]
then
	echo -e "\tResizing..."
	SIZE=(`/usr/bin/identify -format "%w %h" "$IMG"`)
	X=$((SIZE[0]*RES[1]))
	Y=$((SIZE[1]*RES[0]))

	# calc wallpaper size and area to cut
	WCUT=0
	HCUT=0
	test $X -ge $Y &&
	W=$((X/SIZE[1])) H=${RES[1]}      WCUT=$(((W-RES[0])/2)) ||
	W=${RES[0]}      H=$((Y/SIZE[0])) HCUT=$(((H-RES[1])/2))

	# create wallpaper
	mkdir -p "$TMPPATH" &&
	convert "$IMG" -resize ${W}x${H} -shave ${WCUT}x${HCUT} "$WALL"
fi &&
echo -e "\tOutput: `/usr/bin/identify "$WALL"`" &&
echo -e "\tSetting..." &&
( pidof nautilus &&
    gconftool-2 -t str --set /desktop/gnome/background/picture_filename "$WALL" ||
  /usr/bin/feh --bg-center "$WALL" ) &&
#/usr/bin/xv -root -quit "$WALL" &&
echo "}}} Done" || exit 1

# clean
rm -rf "$TMP"

