#!/bin/bash
set -ex

if grep -q redhat /etc/resolv.conf; then
    nmcli radio wifi on
else
    nmcli radio wifi off
    nmcli --ask con up id 'Brno (BRQ)'
fi

klist || kinit

pgrep hexchat || hexchat & disown
pgrep firefox || firefox & disown
pgrep --full 'firefox -P work' || firefox -P work & disown
