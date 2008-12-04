#!/bin/sh
GAME_PATH=$HOME/dev/zcode/
ZGAME=$(cd $GAME_PATH/_games/ && /bin/ls -1 | sed 's/\.[^.]*//' | /home/lukas/dev/menus/menu.sh "PLAY GAME:")

if [ $? -eq 0 ]
then
	$GAME_PATH/_rungame.sh $ZGAME
fi

