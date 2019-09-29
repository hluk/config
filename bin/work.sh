#!/bin/bash
set -ex

VPN=${VPN:-'Brno (BRQ)'}

#if grep -q redhat /etc/resolv.conf; then
#    nmcli radio wifi on
#else
#    nmcli radio wifi off
#fi

nmcli --ask con up id "$VPN"

klist || kinit

maybe_run() {
    pgrep --full "$@" || "$@" &>/dev/null & disown
}

maybe_run konversation
maybe_run firefox
maybe_run firefox -P work
