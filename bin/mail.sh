#!/bin/bash
fix_path=$(dirname "$0")/irc-bin
export PATH="$fix_path:$PATH"
export MOZ_ENABLE_WAYLAND=1
exec thunderbird-wayland
