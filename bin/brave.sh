#!/bin/bash
#chromium --proxy-server=localhost:8118 --enable-greasemonkey --enable-user-scripts --enable-extensions --enable-plugins --enable-sync "$@"
#chromium --enable-greasemonkey --enable-user-scripts --enable-extensions --enable-plugins --enable-sync "$@"
#chromium "$@"

export LIBVA_DRIVER_NAME=iHD
export SDL_VIDEODRIVER=wayland
args=(
    #--enable-features=UseOzonePlatform
    --ozone-platform=wayland
    #--ozone-platform=x11
    #--ozone-platform-hint=auto

    --ignore-gpu-blocklist
    --enable-gpu-rasterization
    --enable-zero-copy
    --disable-gpu-driver-bug-workarounds
    --enable-accelerated-video-decode
    --enable-features=VaapiVideoDecoder
    # --use-gl=egl
    --use-gl=angle

    --enable-gpu
    --enable-gpu-memory-buffer-video-frames
    --enable-accelerated-2d-canvas
    --enable-accelerated-vpx-decode
    --enable-native-gpu-memory-buffers
    --gpu-no-context-lost
    # --in-process-gpu
)
exec flatpak run com.brave.Browser "${args[@]}"
