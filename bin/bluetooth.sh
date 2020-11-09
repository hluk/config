#!/bin/bash
set -exo pipefail

id=$(rfkill list | grep ': hci0: Bluetooth' | grep -o '^[0-9]\+')
#name='JBL REFLECT FLOW'
device='98:52:3D:09:A0:17'

if [[ $1 == "off" ]]; then
    rfkill block "$id"
else
    rfkill unblock "$id"
    #device=$(bluetoothctl devices | grep -F "$name" | cut -d ' ' -f 2)
    sleep 1
    while ! bluetoothctl connect "$device"; do
        sleep 1
    done
fi
