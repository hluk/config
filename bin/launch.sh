#!/bin/bash
[ $# -eq 0 ] && exit 1

# safely launch application and keep it running
pidof $1 && killall $1
pidof $1 && killall -9 $1

while :
do
    $@
    if [ $? -eq 127 ]
    then
        break;
    fi

    if [ -n "$LAUNCH_CONDITION" ]
    then
        eval $LAUCH_CONDITION || break
    fi
done

