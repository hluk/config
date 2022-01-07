#!/bin/sh
#chromium --proxy-server=localhost:8118 --enable-greasemonkey --enable-user-scripts --enable-extensions --enable-plugins --enable-sync "$@"
#chromium --enable-greasemonkey --enable-user-scripts --enable-extensions --enable-plugins --enable-sync "$@"
#chromium "$@"

export LIBVA_DRIVER_NAME=iHD
exec chromium-freeworld \
    --enable-features=UseOzonePlatform \
    --ozone-platform=wayland \
    --user-data-dir="$HOME/work/chromium-profile" \
    "$@"
