#!/bin/sh
#export CHROMIUM_USER_FLAGS="--ignore-gpu-blacklist --enable-webgl --enable-gl-multisampling --enable-accelerated-compositing"
#exec /usr/bin/chromium $@
#exec /usr/bin/firefox $@
#exec /usr/bin/chromium-browser $@

export LD_PRELOAD="$HOME/dev/flash_unlink/flash_unlink.so"
#exec /usr/bin/firefox-nightly $@
exec /usr/bin/firefox $@
#exec /usr/bin/chromium $@

