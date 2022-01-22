#!/bin/sh
#chromium --proxy-server=localhost:8118 --enable-greasemonkey --enable-user-scripts --enable-extensions --enable-plugins --enable-sync "$@"
#chromium --enable-greasemonkey --enable-user-scripts --enable-extensions --enable-plugins --enable-sync "$@"
#chromium "$@"

export LIBVA_DRIVER_NAME=iHD
exec chromium-freeworld \
    --enable-features=UseOzonePlatform \
    --ozone-platform=wayland \
    --user-data-dir="$HOME/work/chromium-profile" \
    --ignore-gpu-blocklist \
    --enable-gpu-rasterization \
    --enable-zero-copy \
    --disable-gpu-driver-bug-workarounds \
    --enable-accelerated-video-decode \
    --enable-features=VaapiVideoDecoder \
    --use-gl=egl \
    "$@"
