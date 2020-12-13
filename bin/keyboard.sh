#!/bin/bash
set -xeu

k="input type:keyboard"
msg=$(cat <<EOD
$k repeat_delay 250
$k repeat_rate 45
$k xkb_model pc104
$k xkb_options "grp:shifts_toggle,caps:escape"
$k xkb_layout "us,us,cz"
$k xkb_variant ",dvorak,"
EOD
)
swaymsg "$msg"
