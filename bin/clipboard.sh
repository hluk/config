#!/bin/bash
#VERSION=debug
#VERSION=release
#CMD=~/dev/copyq-build/$VERSION/copyq
CMD=~/dev/copyq/build/copyq

[ "$VERSION" = "debug" ] && ulimit -c 50000

if [ $# -gt 1 ]
then
    "$CMD" "$@" 2>/dev/null
else
    "$CMD" toggle 2>/dev/null || exec "$CMD"
fi

