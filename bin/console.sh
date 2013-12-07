#!/bin/bash
xrdb -merge ~/.Xresources
x=`dirname $0`/screen.sh
#exec urxvt -icon /usr/share/icons/Tango/scalable/apps/terminal.svg -tn rxvt-256color -e "$x"
#exec gnome-terminal --maximize -e "$x"
#exec sakura -e "$x"
#exec xterm -e "$x"
#export TERM=konsole-256color; exec konsole --hide-tabbar --hide-menubar --profile Screen
#exec Terminal -e "$x"
exec xfce4-terminal --maximize -e "$x"
#exec roxterm

