#!/bin/bash
ulimit -c 50000
~/dev/copyq-build/debug/copyq toggle 2>/dev/null ||
exec ~/dev/copyq-build/debug/copyq

