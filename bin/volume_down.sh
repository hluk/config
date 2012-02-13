#!/bin/bash
#pidof -s pulseaudio &&
    #"`dirname $0`/pavolume.sh" -1000 ||
    "`dirname $0`/volume.sh" 2%-
#pacmd dump|awk --non-decimal-data '$1~/set-sink-volume/{system ("pacmd "$1" "$2" "$3-5000)}'

