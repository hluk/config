#!/bin/sh
#setxkbmap -print|grep -q cz && setxkbmap us || setxkbmap cz
# [shift + left alt] to toggle layout (alternative layout shown with 'scroll lock' LED)
setxkbmap -layout us,cz -variant ,qwerty -option 'grp:alt_shift_toggle,grp_led:scroll'

