#!/bin/sh
#export MENU_FONT="-*-fixed-medium-r-normal-*-10-*-*-*-*-*-iso10646-1"
#export MENU_FONT="-*-terminus-bold-*-*-*-14-*-*-*-*-*-iso10646-1"
#export MENU_FONT="-*-helvetica-bold-r-*-*-11-*-*-*-*-*-iso10646-1"
export MENU_FONT="-*-verdana-bold-r-*-*-10-*-*-*-*-*-iso10646-1"
# gray
#export MENU_BG="#2e3436"
#export MENU_FG="#babdb6"
#export MENU_SELBG="#414141"
#export MENU_SELFG="#73d216"
# blue
export MENU_BG="#106080"
export MENU_FG="#cceeff"
export MENU_SELBG="#207090"
export MENU_SELFG="#ffffff"

/home/lukas/dev/menus/dmenu-3.4/dmenu -p "$@" -fn $MENU_FONT -nb $MENU_BG -nf $MENU_FG -sb $MENU_SELBG -sf $MENU_SELFG

