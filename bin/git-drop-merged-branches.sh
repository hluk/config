#!/bin/bash
# Drops local git branches that have been merged.
set -euo pipefail

branches=$(git branch --merged | grep -Ev "(^\*|master|main|dev)")
if [[ -z "$branches" ]]; then
    exit 0
fi

echo "Removing branches:"
echo "$branches"

echo
read -p "Are you sure? [y/N] " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

xargs git branch -d <<< "$branches"
