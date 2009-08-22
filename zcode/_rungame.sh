#!/bin/sh
NAME=$1
ZCODEROOT="$HOME/dev/zcode"
GAMEFILE=`ls "$ZCODEROOT/_games/$NAME".*`

#SAVEDIR="$ZCODEROOT/_saved/$NAME/"
#(mkdir -p "$SAVEDIR" && cd "$SAVEDIR" &&
	#"$HOME/dev/zcode/_apps/garglk/build/dist/gargoyle" "$GAMEFILE")

JSGAMEFILE="/home/lukas/apps/parchment/stories/$NAME.js"
(ls "$JSGAMEFILE" ||
 (cd /home/lukas/apps/parchment &&
  python zcode2js.py "$GAMEFILE" > "$JSGAMEFILE") &&
 ~/chromium.sh "file:///home/lukas/apps/parchment/parchment.html?story=file://$JSGAMEFILE")

exit $?

