#!/bin/bash
# Show window selection in Sway Wayland compositor.
#
# Install dependencies:
#   cargo install swayr
#
# Update dependencies:
#   cargo install install-update
#   cargo install-update -- swayr
#

set -eo pipefail

export PATH=$HOME/.cargo/bin:$PATH

if [[ $# -gt 0 ]]; then
    exec swayr "$@"
else
    if ! pidof -q swayrd; then
        exec swayrd
    fi
fi
