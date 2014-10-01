#!/bin/bash
version=debug
rundir=~/dev/build/copyq
cmd=$rundir/$version/copyq

[ "$VERSION" = "debug" ] && ulimit -c unlimited

if [ $# -gt 1 ]; then
    "$cmd" "$@" 2>/dev/null
else
    cd "$rundir" &&
    "$cmd" toggle 2>/dev/null || {
        mv ~/copyq.log{,.old}
        export COPYQ_LOG_FILE="$HOME/copyq.log"
        export COPYQ_LOG_LEVEL=debug
        exec "$cmd"
        #"$cmd" |& ~/dev/traypost/build/traypost --record-end --icon /usr/share/icons/Tango/22x22/actions/find.png
    }
fi

