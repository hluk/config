#!/bin/bash
#export CHROMIUM_USER_FLAGS="--ignore-gpu-blacklist --enable-webgl --enable-gl-multisampling --enable-accelerated-compositing"
#exec /usr/bin/chromium $@
#exec /usr/bin/firefox $@
#exec /usr/bin/chromium-browser $@

# this will leave all flash videos in /tmp
#export LD_PRELOAD="$HOME/dev/flash_unlink/flash_unlink.so"

#B=/usr/bin/firefox
B="/usr/bin/chromium --ignore-gpu-blacklist"
#B=/usr/bin/chromium-browser
#B=/usr/bin/firefox-nightly
#B=/usr/bin/opera
#B=/usr/bin/opera-next

exec $B "$@" &>/dev/null

# opera
# + good build-in content blocking
# - can crash X11

# chromium
# + good search highlighting and handles diacritics (e.g.: e is e, ě, é ...)
# - google reader sometimes eats lot of cpu when idle (probably bug)
# - missing good addons (no low level functions for blocking content)

# firefox
# + fast google reader
# - bad search highlighting and doesn't handle diacritics
# - periodically hangs for few seconds

