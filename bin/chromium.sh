#!/bin/sh
#chromium --proxy-server=localhost:8118 --enable-greasemonkey --enable-user-scripts --enable-extensions --enable-plugins --enable-sync "$@"
#chromium --enable-greasemonkey --enable-user-scripts --enable-extensions --enable-plugins --enable-sync "$@"
chromium "$@"

