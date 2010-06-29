#!/bin/sh
NAME=$1
ZCODEROOT="$HOME/dev/zcode"
GAMEFILE=`ls "$ZCODEROOT/_games/$NAME".*`

#SAVEDIR="$ZCODEROOT/_saved/$NAME/"
#(mkdir -p "$SAVEDIR" && cd "$SAVEDIR" &&
	#"$HOME/dev/zcode/_apps/garglk/build/dist/gargoyle" "$GAMEFILE")

(
    cd /home/lukas/www/parchment &&
    python tools/zcode2js.py "$GAMEFILE" > "stories/$NAME.js" &&
    $BROWSER "http://127.0.0.1:8080/parchment/parchment.html?story=stories/$NAME.js"
)

exit $?

