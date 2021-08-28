#!/bin/bash
# $ sudo dnf install android-tools
#
# Click 7 times on Build Number under About.
#
# Enable "Wireless debugging" in Developer options.
#
# Select option "Pair device with pairing code".
#
# Run following commands (note that the ports will change on the phone):
#
#     adb pair ipaddr:port1 code
#     adb connect ipaddr:port2
#
# List user installed packages:
#
#     adb shell cmd package list packages -3
#
# Print help:
#
#     adb shell cmd package help
set -ex

disable=(
    com.android.chrome

    com.facebook.appmanager
    com.facebook.katana
    com.facebook.services
    com.facebook.system

    com.samsung.android.bixby.service
    com.samsung.android.app.settings.bixby

    com.microsoft.appmanager
    com.microsoft.skydrive
)

for app in "${disable[@]}"; do
    adb shell pm disable-user $app || true
done
