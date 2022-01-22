#!/bin/bash
set -ex
ssid=MagicWand2
nmcli con add type wifi con-name "$ssid" autoconnect yes ssid "$ssid"
nmcli con modify "$ssid" 802-11-wireless.mode ap 802-11-wireless.band bg ipv4.method shared
nmcli con modify "$ssid" wifi-sec.key-mgmt wpa-psk
read -p Password: -s password
nmcli con modify "$ssid" wifi-sec.psk "$password"
nmcli con up "$ssid"
