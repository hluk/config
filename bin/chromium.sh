#!/bin/sh
chromium-bin --proxy-server=localhost:8118 --enable-greasemonkey --enable-user-scripts --enable-extensions --enable-plugins --enable-sync "$@"

