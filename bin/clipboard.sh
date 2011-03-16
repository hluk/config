#!/bin/bash
ulimit -c 50000
~/dev/copyq-build/debug/copyq toggle ||
exec ~/dev/copyq-build/debug/copyq

