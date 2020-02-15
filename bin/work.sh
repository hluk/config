#!/bin/bash
set -ex

VPN=${VPN:-'Brno (BRQ)'}
#VPN='Phoenix (PHX2)'

#if grep -q redhat /etc/resolv.conf; then
#    nmcli radio wifi on
#else
#    nmcli radio wifi off
#fi

nmcli --ask con up id "$VPN" || true

kinit

run() {
    "$@" &>/dev/null & disown
}

maybe_run() {
    pgrep --full "$@" || run "$@"
}

maybe_run firefox
maybe_run firefox -P work
run "$(dirname "$0")/irc.sh"
