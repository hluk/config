#!/bin/sh
NAME=$1
ZCODEROOT="$HOME/dev/zcode"
GAMEFILE=`ls "$ZCODEROOT/_games/$NAME".*`
SAVEDIR="$ZCODEROOT/_saved/$NAME/"

(mkdir -p "$SAVEDIR" && cd "$SAVEDIR" &&
	"$HOME/dev/zcode/_apps/garglk/build/dist/gargoyle" "$GAMEFILE")

exit $?

