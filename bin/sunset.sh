#!/bin/bash
set -e

pkill redshift || true
pkill wlsunset || true

lat=48.2
lon=16.67
min_temp=4500
max_temp=6500
config=/tmp/redshift-$USER

if [[ $XDG_SESSION_TYPE == "x11" ]]; then
    exec redshift -l "$lat:$lon" -t "$max_temp:$min_temp" -r
else
    wlsunset -l "$lat" -L "$lon" -t "$min_temp" -T "$max_temp" 2>&1 | {
        while read -r line; do
            temperature=$(grep -Eo '[0-9]{4}' <<< "$line") || continue
            echo "$temperature" > "$config"
        done
    }
fi
