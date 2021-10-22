#!/bin/bash
set -eu

# man 7 xkeyboard-config
# ~/.config/xkb/symbols/custom
msg=$(sed 's/^/input type:keyboard /' <<EOD
repeat_delay 250
repeat_rate 45
xkb_model pc104
xkb_options "grp:ctrls_toggle,numpad:mac"
xkb_layout "custom,cz"
xkb_variant ",qwerty"
EOD
)
swaymsg "$msg"
