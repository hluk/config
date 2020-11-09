#!/bin/bash
set -e

#exec $(dirname "$0")/console.sh irssi

if pidof hexchat; then
    exit
fi

fix_path=$(dirname "$0")/irc-bin
export PATH="$fix_path:$PATH"
exec hexchat "$@"
