#!/bin/bash
set -euo pipefail

config=/tmp/redshift-$USER
min_amount=2000
max_amount=6500

pkill redshift || true
pkill wlsunset || true

diff=$1
amount=$(cat "$config" || echo $max_amount)
new_amount=$((amount + diff))

if [[ $new_amount < $min_amount ]]; then
    new_amount=$min_amount
elif [[ $new_amount > $max_amount ]]; then
    new_amount=$max_amount
fi

echo "$new_amount" > "$config"

if [[ $XDG_SESSION_TYPE == "x11" ]]; then
    exec redshift -P -O "$new_amount"
else
    exec wlsunset -t "$new_amount" -T "$((new_amount + 1))"
fi
