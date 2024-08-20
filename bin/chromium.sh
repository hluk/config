#!/bin/bash
#chromium --proxy-server=localhost:8118 --enable-greasemonkey --enable-user-scripts --enable-extensions --enable-plugins --enable-sync "$@"
#chromium --enable-greasemonkey --enable-user-scripts --enable-extensions --enable-plugins --enable-sync "$@"
#chromium "$@"

export PROFILE=${PROFILE:-}
export LIBVA_DRIVER_NAME=iHD
export SDL_VIDEODRIVER=wayland
args=(
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
    #--ozone-platform=x11
    #--ozone-platform-hint=auto

    # --user-data-dir="$HOME/work/chromium-profile$PROFILE"
    --ignore-gpu-blocklist
    --enable-gpu-rasterization
    --enable-zero-copy
    --disable-gpu-driver-bug-workarounds
    --enable-accelerated-video-decode
    --enable-features=VaapiVideoDecoder
    --use-gl=egl

    --enable-gpu
    --enable-gpu-memory-buffer-video-frames
    --enable-accelerated-2d-canvas
    --enable-accelerated-vpx-decode
    --enable-native-gpu-memory-buffers
    --gpu-no-context-lost
    --disable-infobars
    # --no-sandbox
    --window-position="0,0"
    --no-first-run
    # --in-process-gpu
    --fullscreen
    # --kiosk

    --disable-features=UserAgentClientHint

    # "https://play.geforcenow.com/mall/#/layout/games/gameSectionGrid?search=false"
    #https://www.netflix.com/browse/my-list
)
#exec gamemoderun chromium-freeworld "${args[@]}" "$@"
#exec gamescope -r 60 -w 1920 -h 1080 -f -- chromium-freeworld "${args[@]}" "$@"
# chromium-browser "${args[@]}" "$@"
flatpak run com.brave.Browser "${args[@]}" "$@"
