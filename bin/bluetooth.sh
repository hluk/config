#!/bin/bash
set -exo pipefail

id=$(rfkill list | grep ': Bluetooth' | grep -o '^[0-9]\+')
#name='JBL REFLECT FLOW'
device='98:52:3D:09:A0:17'

bt_pair() {
    bluetoothctl info "$device" | grep -q "Paired: yes" ||
        bluetoothctl pair "$device"
}

bt_connect() {
    bluetoothctl info "$device" | grep -q "Connected: yes" ||
        bluetoothctl connect "$device"
}

if [[ $1 == "off" ]]; then
    rfkill block "$id"
else
    rfkill unblock "$id"
    #device=$(bluetoothctl devices | grep -F "$name" | cut -d ' ' -f 2)
    sleep 2
    bt_pair || true
    bt_connect || true
fi
