#!/bin/bash
set -xeuo pipefail

music_dir=$HOME/Music

for zip in "$@"; do
    dir="${zip%.*}"
    unzip -d "$music_dir/$dir" "$zip" || exit $?
    rm -v "$zip"
done
