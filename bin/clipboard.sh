#!/bin/bash
set -e

version=release
rundir=~/dev/build/copyq
cmd=$rundir/$version/copyq

# Workaround for bug in Qt 5.14.2.
# https://bugreports.qt.io/browse/QTBUG-84363
export QV4_FORCE_INTERPRETER=1

export COPYQ_LOG_LEVEL=debug
export COPYQ_DEFAULT_ICON=1

# There are some issues accessing clipboard and notifications being focused.
# See: https://github.com/hluk/CopyQ/issues/1243#issuecomment-549040797
#export QT_QPA_PLATFORM=xcb

export QT_QPA_PLATFORM=wayland

export QT_QPA_PLATFORMTHEME=qt5ct

[ "$version" = "debug" ] && ulimit -c unlimited

if [ $# -gt 1 ]; then
    exec "$cmd" "$@"
else
    cd "$rundir"
    "$cmd" toggle || exec "$cmd"
fi &>/dev/null

