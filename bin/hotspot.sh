#!/bin/bash
set -eu
ssid=MagicWand2

read -rp Password: -s password

nmcli connection delete "$ssid" || true

nmcli connection add type wifi con-name "$ssid" \
    autoconnect yes \
    ssid "$ssid" \
    ipv4.method shared \
    802-11-wireless.mode ap \
    802-11-wireless.band bg \
    802-11-wireless-security.key-mgmt wpa-psk \
    802-11-wireless-security.psk "$password" \
    802-11-wireless-security.proto rsn \
    802-11-wireless-security.group ccmp \
    802-11-wireless-security.pairwise ccmp

nmcli con up "$ssid"
