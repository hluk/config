#!/bin/bash
version=debug
rundir=~/dev/build/copyq
cmd=$rundir/$version/copyq

[ "$VERSION" = "debug" ] && ulimit -c 50000

if [ $# -gt 1 ]; then
    "$cmd" "$@" 2>/dev/null
else
    cd "$rundir" &&
    "$cmd" toggle 2>/dev/null || {
        mv ~/copyq.log{,.old}
        exec 2> ~/copyq.log
        exec "$cmd"
        #"$cmd" |& ~/dev/traypost/build/traypost --record-end --icon /usr/share/icons/Tango/22x22/actions/find.png
    }
fi

