#!/bin/bash
set -exuo pipefail

pkill -f 'waybar -b bar-0' || true
pkill -f pomodoro.py || true
pkill -f 'inotifywait .* /tmp/redshift' || true

# exec waybar -b bar-0 -l trace
waybar -b bar-0 > /dev/null &
disown
