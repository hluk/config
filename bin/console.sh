#!/bin/bash
xrdb -merge ~/.Xresources
x=`dirname $0`/screen.sh
#exec gnome-terminal --maximize -- "$x"
export TERM=konsole-256color; exec konsole --hide-tabbar --hide-menubar --profile Screen -e "$x"
#exec st -f 'Fira Mono:size=11' -g 200x200 -e "$x"
#exec xfce4-terminal --hide-menubar --hide-borders --hide-scrollbar --maximize -e "$x"
#export TERM=screen-256color; exec yakuake
#exec urxvt -icon /usr/share/icons/Tango/scalable/apps/terminal.svg -tn rxvt-256color -e "$x"
#exec sakura -e "$x"
#exec xterm -e "$x"
#exec Terminal -e "$x"
#exec alacritty -e bash -c "$x"
#exec ~/dev/alacritty/target/release/alacritty -e "$x"
#exec roxterm

