#!/bin/bash
xrdb -merge ~/.Xresources
x=`dirname $0`/screen.sh
#export TERM=konsole-256color; exec konsole --hide-tabbar --hide-menubar --profile Screen
#export TERM=screen-256color; exec yakuake
#exec urxvt -icon /usr/share/icons/Tango/scalable/apps/terminal.svg -tn rxvt-256color -e "$x"
#exec gnome-terminal --maximize -e "$x"
#exec sakura -e "$x"
#exec xterm -e "$x"
#exec Terminal -e "$x"
exec xfce4-terminal --maximize -e "$x"
#exec ~/apps/alacritty/target/release/alacritty -e bash -c "$x"
#exec roxterm

