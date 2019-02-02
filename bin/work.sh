#!/bin/bash
set -ex

if grep -q redhat /etc/resolv.conf; then
    nmcli radio wifi on
else
    nmcli radio wifi off
    nmcli --ask con up id 'Brno (BRQ)'
fi

# Fix hexchat scaling.
if lsusb | grep -q Ergonomic; then
    font_size=9
else
    font_size=15
fi
sed -i 's/^\(text_font.*\) [0-9]\+/\1 '"$font_size"'/' ~/.config/hexchat/hexchat.conf

klist || kinit

pgrep hexchat || hexchat & disown
pgrep firefox || firefox & disown
pgrep --full 'firefox -P work' || firefox -P work & disown
