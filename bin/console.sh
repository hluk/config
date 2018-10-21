#!/bin/bash
xrdb -merge ~/.Xresources
x=`dirname $0`/screen.sh
exec xfce4-terminal --hide-menubar --hide-borders --hide-scrollbar --maximize -e "$x"
#export TERM=konsole-256color; exec konsole --hide-tabbar --hide-menubar --profile Screen -e "$x"
#export TERM=screen-256color; exec yakuake
#exec urxvt -icon /usr/share/icons/Tango/scalable/apps/terminal.svg -tn rxvt-256color -e "$x"
#exec gnome-terminal --maximize -e "$x"
#exec sakura -e "$x"
#exec xterm -e "$x"
#exec Terminal -e "$x"
#exec alacritty -e bash -c "$x"
#exec ~/apps/alacritty/target/release/alacritty -e bash -c "$x"
#exec roxterm

