#!/bin/bash
if [ -z "$1" ]; then
    exec "$0" "$(dirname "$0")/screen.sh"
fi

#xrdb -merge ~/.Xresources
#exec gnome-terminal --wait --maximize --hide-menubar -- "$@"
exec konsole --hide-tabbar --hide-menubar --profile Screen -e "$@"
#kitty -- "$@"
#exec st -f 'Fira Mono:size=11' -g 200x200 -e "$*"
#exec xfce4-terminal --hide-menubar --hide-borders --hide-scrollbar --maximize -e "$*"
#exec urxvt -icon /usr/share/icons/Tango/scalable/apps/terminal.svg -tn rxvt-256color -e "$*"
#exec sakura -e "$*"
#exec xterm -e "$*"
#exec Terminal -e "$*"
#exec alacritty -e bash -c "$*"
#exec ~/dev/alacritty/target/release/alacritty -e "$*"

