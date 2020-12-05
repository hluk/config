#!/bin/bash
lock_after_minutes=20
screen_off_after_minutes=25
# https://github.com/swaywm/swayidle/blob/master/swayidle.1.scd
pkill swayidle
exec swayidle -w \
    timeout $((lock_after_minutes * 60)) ~/dev/bin/lock.sh \
    timeout $((screen_off_after_minutes * 60)) 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' \
    before-sleep ~/dev/bin/lock.sh
