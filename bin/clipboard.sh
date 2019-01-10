#!/bin/bash
version=release
rundir=~/dev/build/copyq
cmd=$rundir/$version/copyq

export COPYQ_LOG_LEVEL=debug

[ "$VERSION" = "debug" ] && ulimit -c unlimited

if [ $# -gt 1 ]; then
    exec "$cmd" "$@"
else
    cd "$rundir" &&
    "$cmd" toggle || exec "$cmd"
fi &>/dev/null

