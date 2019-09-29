#!/bin/bash
# $ sudo dnf install android-tools
#
# Click 7 times on Build Number under About.
#
# Enable USB debugging in Developer options.
#
set -e
disable=(
    com.android.chrome
)

for app in "${disable[@]}"; do
    adb shell pm disable-user $app
done
