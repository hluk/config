#!/bin/bash
set -exuo pipefail

files=(
    ~/.config/copyq
    ~/.config/keepassxc.kdbx
    ~/.gmailctl/config.jsonnet
    ~/.gnupg
    ~/.ssh
)

date=$(date --iso-8601)
output=~/Documents/backup/backup-$date.7z

7z a -p "$output" "${files[@]}"

echo "Backup: $output"
