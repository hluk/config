#!/bin/bash
set -e

# Qt framework has problems showing tray icon when desktop environment starts.
sleep "${1:-5}"

cd ~/dev/xitomatl
exec poetry run xitomatl 2> .xitomatl.log
