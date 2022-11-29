#!/bin/bash
set -euo pipefail

music_dir=${TARGET_DIR:-HOME/Music/disk}

echo "$# files to unpack into $music_dir"
du --total --human-readable "$@"

for zip in "$@"; do
    dir="${zip%.*}"
    unzip -d "$music_dir/$dir" "$zip" || exit $?
    rm -v "$zip"
done
