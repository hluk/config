#!/bin/bash
fix_path=$(dirname "$0")/work-bin
export PATH="$fix_path:$PATH"
export MOZ_ENABLE_WAYLAND=1
exec evolution
