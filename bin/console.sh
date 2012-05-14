#!/bin/bash
xrdb -merge ~/.Xresources
x=`dirname $0`/screen.sh
exec urxvt -icon /usr/share/icons/Tango/scalable/apps/terminal.svg -tn rxvt-256color -e "$x"
#exec gnome-terminal --maximize -e "$x"
#exec sakura -e "$x"
#exec xterm -e "$x"
#exec konsole --profile Screen
#exec Terminal -e "$x"
#exec roxterm

