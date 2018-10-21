#!/bin/bash
set -e

nmcli con up id 'Brno (BRQ)'

klist || xfce4-terminal -e kinit

pgrep hexchat || hexchat &

pgrep --full 'firefox -P work' || exec firefox -P work
