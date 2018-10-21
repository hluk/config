#!/bin/bash
set -xeuo pipefail

config=~/.redshift
min_amount=2000
max_amount=6500

pkill redshift || true

diff=$1
amount=$(cat "$config" || echo $max_amount)
new_amount=$((amount + diff))

if [[ $new_amount < $min_amount ]]; then
    new_amount=$min_amount
elif [[ $new_amount > $max_amount ]]; then
    new_amount=$max_amount
fi

redshift -O "$new_amount"
echo "$new_amount" > "$config"
