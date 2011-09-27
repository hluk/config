#!/bin/bash
#VERSION=debug
VERSION=release

[ "$VERSION" = "debug" ] && ulimit -c 50000
~/dev/copyq-build/$VERSION/copyq toggle 2>/dev/null ||
exec ~/dev/copyq-build/$VERSION/copyq

