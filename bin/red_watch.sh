#!/bin/bash
set -eo pipefail

watch_file=/tmp/redshift-$USER

if [[ ! -f "$watch_file" ]]; then
    script_root="$(dirname "$(readlink -f "$0")")"
    "$script_root/sunset.sh"
fi

cat "$watch_file";
while inotifywait -qq -e modify "$watch_file"; do
    cat "$watch_file";
done
