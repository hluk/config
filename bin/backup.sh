#!/bin/bash
set -exuo pipefail

files=(
    ~/.config/copyq
    ~/.local/share/copyq/copyq/items
    ~/.config/keepassxc.kdbx
    ~/.gmailctl/config.jsonnet
    ~/.gnupg
    ~/.ssh
)

date=$(date --iso-8601)
output=~/Documents/backup/backup-$date.7z

7z a -p "$output" "${files[@]}"

echo "Backup: $output"
