#!/bin/bash
NAME=$1
ZCODEROOT="$HOME/dev/zcode"
GAMEFILE=`ls "$ZCODEROOT/_games/$NAME".*`
OFILE=stories/$NAME.js
BROWSER=${BROWSER:-chromium}
#SERVER=http://127.0.0.1:8080
SERVER=file:///home/lukas/www

#SAVEDIR="$ZCODEROOT/_saved/$NAME/"
#(mkdir -p "$SAVEDIR" && cd "$SAVEDIR" &&
	#"$HOME/dev/zcode/_apps/garglk/build/dist/gargoyle" "$GAMEFILE")

(
if echo "$GAMEFILE" | grep -q '\.gblorb$'; then
    cd /home/lukas/www/quixe/ &&
        python2 tools/game2js.py "$GAMEFILE" > "$OFILE" &&
        $BROWSER "$SERVER/quixe/play-remote.html?story=$OFILE"
elif echo "$GAMEFILE" | grep -q '\.blb$'; then
    LD_LIBRARY_PATH=$HOME/apps/garglk/build/linux.release/garglk ~/apps/garglk/build/linux.release/glulxe/glulxe "$GAMEFILE"
else
    cd /home/lukas/www/parchment &&
        python2 tools/zcode2js.py "$GAMEFILE" > "$OFILE" &&
        $BROWSER "$SERVER/parchment/index.html?story=$OFILE"
fi
)

exit $?

