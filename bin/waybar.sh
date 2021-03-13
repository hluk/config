#!/bin/bash
set -exuo pipefail

pkill waybar || true
pkill -f pomodoro.py || true
pkill -f 'inotifywait .* /tmp/redshift' || true

waybar -b bar-0 > /dev/null &
disown
