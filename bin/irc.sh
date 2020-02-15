#!/bin/bash
set -e

#exec $(dirname "$0")/console.sh irssi

export PATH="$(dirname "$0")/irc-bin:$PATH"
exec hexchat "$@"
