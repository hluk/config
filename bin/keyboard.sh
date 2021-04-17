#!/bin/bash
set -xeu

k="input type:keyboard"
# man 7 xkeyboard-config
msg=$(cat <<EOD
$k repeat_delay 250
$k repeat_rate 45
$k xkb_model pc104
$k xkb_options "grp:shifts_toggle,caps:ctrl_modifier,numpad:mac"
$k xkb_layout "us,cz"
$k xkb_variant ",qwerty"
EOD
)
swaymsg "$msg"
