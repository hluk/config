#!/bin/bash
version=debug
rundir=~/dev/build/copyq
cmd=$rundir/$version/copyq

export COPYQ_LOG_LEVEL=debug

[ "$VERSION" = "debug" ] && ulimit -c unlimited

if [ $# -gt 1 ]; then
    "$cmd" "$@" 2>/dev/null
else
    cd "$rundir" &&
    "$cmd" toggle 2>/dev/null || exec "$cmd"
fi

