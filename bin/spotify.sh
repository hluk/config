#!/bin/bash
set -e

# Collect DBUS_SESSION_BUS_ADDRESS from running process
set_dbus_adress()
{
    USER=$1
    PROCESS=$2
    PID=$(pgrep -o -u "$USER" "$PROCESS")
    ENVIRON=/proc/$PID/environ

    if [ -e "$ENVIRON" ]; then
        export $(grep -z DBUS_SESSION_BUS_ADDRESS "$ENVIRON")
    else
        echo "Unable to set DBUS_SESSION_BUS_ADDRESS."
        exit 1
    fi
}

# Check if DBUS_SESSION is set
if [ -z $DBUS_SESSION_BUS_ADDRESS ]; then
    #echo "DBUS_SESSION_BUS_ADDRESS not set. Guessing."
    set_dbus_adress `whoami` spotify
fi

cmd="${1:-PlayPause}"
dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 "org.mpris.MediaPlayer2.Player.$cmd"

