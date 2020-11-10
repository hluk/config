#!/bin/bash
set -eo pipefail

watch_file=/tmp/redshift-$USER

cat "$watch_file";
while inotifywait -qq -e modify "$watch_file"; do
    cat "$watch_file";
done
