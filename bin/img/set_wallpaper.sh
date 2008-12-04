#!/bin/sh
# vim: foldmarker=<<<,>>>
WALLPATH="$HOME/wallpapers"
CMD="/bin/ls -1"

# redirect output to LOGFILE
if [ -n "$LOGFILE" ]
then
	exec 1>>"$LOGFILE"
fi

trap 'echo "}}} FAILED!"; exit 1' TERM QUIT INT

# take wallpaper as parameter or random from WALLPATH
if [ -n "$1" ]
then
	echo "$(date -R): Setting wallpaper \"$1\" {{{"
	/usr/bin/wget -q -O "/home/lukas/dev/img/wallpaper.tmp.jpg" "$1" && IMG="/home/lukas/dev/img/wallpaper.tmp.jpg" || IMG="$1"
else 
	IMG=$WALLPATH/$(cd $WALLPATH &&
	$CMD | awk '
BEGIN{
	srand()
	n=int(rand()*'$(eval $CMD|wc -l)' )
}

n==NR{
	printf("%s\0",$0)
	quit
}'
	) || exit $?
	echo "$(date -R): Setting random wallpaper \"$IMG\" {{{"
fi


echo -e "\tInput..."$(/usr/bin/identify "$IMG")
echo -e "\tResizing..."
# PIL
python -c "
W = 1280; H=1024
import Image
im = Image.open('$IMG')
if float(im.size[0])/im.size[1] >= float(W)/H:
	w, h = int( float( H*im.size[0] )/float( im.size[1] ) ), H
else:
	w, h = W, int( float( W*im.size[1] )/float( im.size[0] ))
out = im.resize((w,h), Image.BICUBIC)
out.save('/home/lukas/dev/img/_wallpaper.png', 'PNG')" &&
echo -e "\tOutput..."$(/usr/bin/identify "/home/lukas/dev/img/_wallpaper.png") &&
echo -e "\tSetting..." &&
/usr/bin/feh --bg-center "/home/lukas/dev/img/_wallpaper.png" &&
echo "}}} Done!" || exit 1

# write to log
#echo "$(date -R): Image \"$IMG\" set as wallpaper." >> $0.log

