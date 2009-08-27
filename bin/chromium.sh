#!/bin/sh
chromium-bin --enable-sync --proxy-server=localhost:8118 --enable-greasemonkey --enable-user-scripts --enable-extensions --enable-plugins $@

