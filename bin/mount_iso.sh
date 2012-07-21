#!/bin/sh
/usr/lib/gvfs/gvfsd-archive "file=$1" 2>&1 > /dev/null &
disown
