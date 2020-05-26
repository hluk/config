#!/bin/bash
# $ sudo dnf install android-tools
#
# Click 7 times on Build Number under About.
#
# Enable USB debugging in Developer options.
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

    com.samsung.android.allshare.service.mediashare
    com.samsung.android.allshare.service.fileshare
    com.samsung.android.calendar
    com.samsung.android.providers.media

    com.samsung.android.bixby.service
    com.samsung.android.app.settings.bixby
)

for app in "${disable[@]}"; do
    adb shell pm disable-user $app
done
