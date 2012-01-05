#!/bin/bash
CONF=~/.redshift
MAX=6500

killall -q redshift

if [ $# -gt 0 ]
then
    # restore configuration
    [ -r "$CONF" ] && T=`< "$CONF"` || T=$MAX

    # add argument
    T=$(($T+$1))
    [ $T -lt $MAX ] || T=$MAX
else
    T=$MAX
fi

# set and store new value
#redshift -v -O $T && echo $T > "$CONF"
#redshift -v -O $T && echo $T > "$CONF" && notify-send -i redshift -u low -t 1000 Redshift "<b>$T</b>"
redshift -v -O $T && echo $T > "$CONF"

# show osd
killall -q osd_cat
osd_cat -c white -O 1 -d 1 -A center -p middle -b percentage -P "$((T*100/MAX))" -T "redshift $T" &

