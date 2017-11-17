#!/bin/bash
music_dir=$HOME/Music

for x in "$@"; do
    mv -v "$x" "$music_dir" || exit $?
done

(
cd "$music_dir" &&
for x in "$@"; do
    unzip -d "${x%.*}" "$x" || exit $?
done
)

