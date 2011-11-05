#!/bin/sh

tmp=${TMPDIR-/tmp}/pacman-disowned-$UID-$$
db=$tmp/db
fs=$tmp/fs

mkdir "$tmp"
trap  'rm -rf "$tmp"' EXIT

pacman -Qlq | sort -u > "$db"

find /bin /etc /lib /sbin /usr \
  ! -name lost+found \
  \( -type d -printf '%p/\n' -o -print \) | sort > "$fs"

# foreign files
comm -23 "$fs" "$db"
# missing files
cat "$db"|while read x; do [ -e "$x" ] || echo "    $x"; done

