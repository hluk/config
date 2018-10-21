#!/bin/bash
set -e

nmcli --ask con up id 'Brno (BRQ)'

klist || kinit

pgrep hexchat || hexchat & disown

pgrep --full 'firefox -P work' || firefox -P work & disown
