#!/bin/bash
set -e

VPN=${VPN:-'Brno (BRQ)'}
#VPN='Phoenix (PHX2)'

dir=$(dirname "$0")
browser=$dir/browser.sh

run() {
    "$@" &>/dev/null & disown
}

is_running() {
    pgrep --full "$*" >/dev/null
}

if [[ $1 == "off" ]]; then
    nmcli --ask con down id "$VPN"

    kdestroy -A

    copyq maybeWork
elif [[ $1 == "on" ]]; then
    nmcli --ask con up id "$VPN" || true

    kinit "$USER@IPA.REDHAT.COM"

    is_running firefox || run "$browser"
    is_running firefox -P work || run "$browser" -P work
    run "$dir/irc.sh"

    is_running thunderbird || run "$dir/mail.sh"

    copyq maybeWork
else
    echo "usage: $0 {off|on}"
    exit 1
fi
