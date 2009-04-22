#!/bin/sh
#NAME=$(echo $0 | sed '{s/^.*\///;s/\.sh$//}')
NAME=$1
ZCODEROOT=$HOME/dev/zcode
GAMEFILE=$ZCODEROOT/_games/$NAME.*
SAVEDIR=$ZCODEROOT/_saved/$NAME/
#NFROTZ="$ZCODEROOT/nfrotz-0.3.3/nfrotz -e"
#BGCOLOR='#400000'
#FONT="xft:Bitstream Vera Sans Mono:size=12"

#(mkdir -p $SAVEDIR && cd $SAVEDIR &&
#urxvtc -b 64 -bd $BGCOLOR -name zmachine -title $NAME \
	#-fn "$FONT" +tr -bg $BGCOLOR --color4 $BGCOLOR \
	#-e /bin/bash -c "sleep 2 && $NFROTZ $GAMEFILE")

(mkdir -p $SAVEDIR && cd $SAVEDIR &&
	$HOME/dev/zcode/_apps/garglk/build/dist/gargoyle $GAMEFILE)

exit $?

