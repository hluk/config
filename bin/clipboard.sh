#!/bin/bash
set -e

version=release
rundir=~/dev/build/copyq
cmd=$rundir/$version/copyq
# if [[ ! -f "$cmd" ]]; then
#     cmd=/usr/bin/copyq
# fi

# Workaround for bug in Qt 5.14.2.
# https://bugreports.qt.io/browse/QTBUG-84363
#export QV4_FORCE_INTERPRETER=1

# export QT_LOGGING_RULES="*.debug=true;qt.*.debug=false"
export COPYQ_LOG_LEVEL=debug
export COPYQ_DEFAULT_ICON=1

#export QT_QPA_PLATFORMTHEME=qt5ct
#export QT_STYLE_OVERRIDE=kvantum

[ "$version" = "debug" ] && ulimit -c unlimited

if [ $# -gt 1 ]; then
    exec "$cmd" "$@"
else
    cd "$rundir"
    "$cmd" toggle || "$cmd" --start-server show
fi &>/dev/null

