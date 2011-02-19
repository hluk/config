#!/bin/sh
export MENU_FONT="Terminus:size=9"
# blue
export MENU_BG="#4080c0"
export MENU_FG="#ffffff"
export MENU_SELBG="#60b0e0"
export MENU_SELFG="#ffffff"

/home/lukas/dev/menus/dmenu/dmenu-4.0/dmenu -p "$@" -fa "$MENU_FONT" -nb "$MENU_BG" -nf "$MENU_FG" -sb "$MENU_SELBG" -sf "$MENU_SELFG"

