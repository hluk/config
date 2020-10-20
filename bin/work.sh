#!/bin/bash
set -e

VPN=${VPN:-'Brno (BRQ)'}
#VPN='Phoenix (PHX2)'

run() {
    "$@" &>/dev/null & disown
}

maybe_run() {
    pgrep --full "$*" >/dev/null || run "$@"
}

if [[ $1 == "off" ]]; then
    nmcli --ask con down id "$VPN"

    kdestroy -A

    copyq maybeWork
elif [[ $1 == "on" ]]; then
    nmcli --ask con up id "$VPN" || true

    kinit "$USER@IPA.REDHAT.COM"

    maybe_run firefox
    maybe_run firefox -P work
    run "$(dirname "$0")/irc.sh"

    copyq maybeWork
else
    echo "usage: $0 {off|on}"
    exit 1
fi
