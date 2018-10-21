#!/bin/bash
set -e

nmcli con up id 'Brno (BRQ)'
klist || xfce4-terminal -e kinit
exec firefox -P work
