#!/bin/bash
set -ex

./_update.awk LIST

args=(
    --exclude=update.sh
    --exclude=pwned.sh
    --exclude=lyrics.py
    --exclude-dir=.git
    -iRE
    -e '^P='
    -e '^\s*pass.'
    -e 'passw(ord|d).*[:=>]'
    -e 'secret'
    .
)
if grep "${args[@]}"; then
    echo 'Passwords detected'
    exit 1
fi

git diff
