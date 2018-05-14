#!/bin/sh
amixer get Master | grep -q '\[on\]' &&
    amixer set Master mute ||
    amixer set Master unmute

