#!/bin/bash
set -ex

VPN=${VPN:-'Brno (BRQ)'}

if grep -q redhat /etc/resolv.conf; then
    nmcli radio wifi on
else
    nmcli radio wifi off
    nmcli --ask con up id "$VPN"
fi

klist || kinit

pgrep konversation || konversation & disown
pgrep firefox || firefox & disown
pgrep --full 'firefox -P work' || firefox -P work & disown
