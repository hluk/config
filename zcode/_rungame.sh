#!/bin/bash
NAME=$1
ZCODEROOT="$HOME/dev/zcode"
GAMEFILE=`ls "$ZCODEROOT/_games/$NAME".*`
OFILE=stories/$NAME.js
BROWSER=${BROWSER:-chromium-browser}

#SAVEDIR="$ZCODEROOT/_saved/$NAME/"
#(mkdir -p "$SAVEDIR" && cd "$SAVEDIR" &&
	#"$HOME/dev/zcode/_apps/garglk/build/dist/gargoyle" "$GAMEFILE")

(
    echo "$GAMEFILE" | grep -q '\.gblorb$' &&
    (
        cd /home/lukas/www/quixe/ &&
        python2 tools/game2js.py "$GAMEFILE" > "$OFILE" &&
        $BROWSER "http://127.0.0.1:8080/quixe/play-remote.html?story=$OFILE"
    ) || (
        cd /home/lukas/www/parchment &&
        python2 tools/zcode2js.py "$GAMEFILE" > "$OFILE" &&
        $BROWSER "http://127.0.0.1:8080/parchment/index.html?story=$OFILE"
    )
)

exit $?

