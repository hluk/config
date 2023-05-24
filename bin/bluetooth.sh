#!/bin/bash
set -exuo pipefail

if [[ ${1:-} == 0 ]]; then
  echo "Blocking bluetooth"
  command=block
else
  echo "Unblocking bluetooth"
  command=unblock
fi

ids=$(
  rfkill -J -o ID,TYPE list |
    jq -r '.rfkilldevices[] | select(.type=="bluetooth") | .id'
)

rfkill $command $ids
