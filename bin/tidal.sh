#!/bin/bash
# Install tidal-hifi:
#
#     git clone https://github.com/Mastermindzh/tidal-hifi.git
#     cd tidal-hifi
#     npm run build-unpacked
#
exec ~/dev/tidal-hifi/dist/linux-unpacked/tidal-hifi \
    --enable-features=UseOzonePlatform \
    --ozone-platform-hint=auto \
    --enable-features=WaylandWindowDecorations
