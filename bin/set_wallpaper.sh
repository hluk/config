#!/bin/bash
# vim: foldmarker=<<<,>>>
# usage:
#   ./set_wallpaper.sh # sets random wallpaper from WALLPATH env
#   ./set_wallpaper.sh image_file
WALLPATH=${WALLPATH:-"$HOME/wallpapers"}

# screen resolution
#RES=(`xdpyinfo|sed -n '/^  dimensions:    /{s/.* \([0-9]\+\)x\([0-9]\+\).*/\1 \2/;p;q}'`) || exit $?
RES=(1920 1080)

TMPPATH="$WALLPATH/_tmp"
TMP="/home/lukas/dev/img/wallpaper.tmp.jpg"

# redirect output to LOGFILE
exec 1> ~/wallpaper.log

trap 'echo "FAILED!"; exit 1' TERM QUIT INT

# take image as parameter or random image from WALLPATH
if [ -n "$1" ]
then
	echo "`date -R`: Setting wallpaper \"$1\""
	/usr/bin/curl -s -o "$TMP" "$1" && IMG="$TMP" || IMG="$1"
else
	IMG="`find "$WALLPATH" -type f | sort -R | head -1`" || exit $?
	#IMG="$WALLPATH/`cd $WALLPATH && /bin/ls -1 *.* | sort -R | head -1`" || exit $?
	echo "`date -R`: Setting random wallpaper \"$IMG\""
fi

echo -e "\tInput: `/usr/bin/identify "$IMG"`"

TMPPATH="$TMPPATH/${RES[0]}x${RES[1]}"
# create wallapaper if it doesn't exist for current resolution
WALL="$TMPPATH/`basename "$IMG"`.png"
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

# set wallpaper
echo -e "\tSetting..." &&
if pidof xfdesktop >/dev/null; then
    PROPERTY="/backdrop/screen0/monitor0/image-path"
    xfconf-query -c xfce4-desktop -p $PROPERTY -s ""
    xfconf-query -c xfce4-desktop -p $PROPERTY -s "$WALL"
    # for terminal fake transparency
    /usr/bin/feh --bg-fill "$WALL" ||
        /usr/bin/xv -root -quit "$WALL"
#elif pidof pcmanfm >/dev/null
#then
    #pcmanfm --set-wallpaper "$WALL"
elif pidof plasma-desktop >/dev/null; then
    ln -f "$WALL" ~/wallpaper.png
    #kquitapp plasma-desktop && sleep 1
    #kwriteconfig --file plasma-desktop-appletsrc --group Containments --group 67 \
        #--group Wallpaper --group image --key wallpaper "$WALL"
    #kwriteconfig --file plasma-desktop-appletsrc --group Containments --group 70 \
        #--group Wallpaper --group image --key wallpaper "$WALL"
    #setsid plasma-desktop
elif pidof nautilus >/dev/null; then
    #gconftool-2 -t str --set /desktop/gnome/background/picture_filename "$WALL"
    gsettings set org.gnome.desktop.background picture-uri file:///"$WALL"
else
    #/usr/bin/feh --no-xinerama --bg-center "$WALL" ||
    /usr/bin/feh --bg-fill "$WALL" ||
        /usr/bin/xv -root -quit "$WALL"
fi &&
echo "Done" || exit 1

# clean
rm -rf "$TMP"

