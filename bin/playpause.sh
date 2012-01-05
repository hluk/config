#!/bin/bash
if ps -eo comm,state|grep -q '^mplayer  *S'; then
    killall -STOP mplayer
else
    killall -CONT mplayer
fi

