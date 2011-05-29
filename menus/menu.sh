#!/bin/sh
#MENU_FONT="Terminus:size=9"
#MENU_FONT="Aller:bold:size=10"
#MENU_FONT="Inconsolata:bold:size=12"
#MENU_FONT="Envy Code R:bold:size=10"
MENU_FONT="Bitstream Vera Sans Mono:bold:size=10"

# blue
#MENU_BG="#4080c0"
#MENU_FG="#ffffff"
#MENU_SELBG="#60b0e0"
#MENU_SELFG="#ffffff"

MENU_BG="#99ccff"
MENU_FG="#000000"
MENU_SELBG="#ffffff"
MENU_SELFG="#000000"

#/home/lukas/dev/menus/dmenu/dmenu-4.0/dmenu -p "$@" -fa "$MENU_FONT" -nb "$MENU_BG" -nf "$MENU_FG" -sb "$MENU_SELBG" -sf "$MENU_SELFG"
#~/apps/dmenu/dmenu-4.2.1/dmenu -t -i -p "$@" -fn "$MENU_FONT" -nb "$MENU_BG" -nf "$MENU_FG" -sb "$MENU_SELBG" -sf "$MENU_SELFG"
#sprinter -t"$@" -l"$@" -w -z 194,16 -g 400
~/dev/sprinter-gtk/sprinter -t"$@" -l"$@" -g -64-1-1

