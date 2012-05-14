#!/bin/bash
# sed -n 's/^##/.\/gconf-shortcut.sh /p' gconf-shortcut.sh|sh
## 1 /home/lukas/dev/bin/console.sh '<Mod4>Q'
## 2 /home/lukas/dev/bin/browser.sh '<Mod4>W'
## 3 "/home/lukas/dev/bin/red.sh +100" '<Mod4><Control>Right'
## 4 "/home/lukas/dev/bin/red.sh -100" '<Mod4><Control>Left'
## 5 "nautilus" '<Mod4>E'

if [ $# -eq 3 ]; then
    gconftool-2 \
        -s /apps/metacity/keybinding_commands/command_"$1" --type=string "$2"  \
        -s /apps/metacity/global_keybindings/run_command_"$1" --type=string "$3" \
        -s /desktop/gnome/keybindings/custom"$1"/action --type=string "${2/Mod4/Super}"  \
        -s /desktop/gnome/keybindings/custom"$1"/binding --type=string "${3/Mod4/Super}"
elif [ $# -eq 2 ]; then
    gconftool-2 \
        -u /apps/metacity/keybinding_commands/command_"$1" \
        -u /apps/metacity/global_keybindings/run_command_"$1" \
        -s /desktop/gnome/keybindings/custom"$1"/action \
        -s /desktop/gnome/keybindings/custom"$1"/binding
elif [ $# -eq 1 ]; then
    gconftool-2 \
        -g /apps/metacity/keybinding_commands/command_"$1" \
        -g /apps/metacity/global_keybindings/run_command_"$1" \
        -g /desktop/gnome/keybindings/custom"$1"/action \
        -g /desktop/gnome/keybindings/custom"$1"/binding
else
    gconftool-2 -R /apps/metacity/keybinding_commands|sed -n '/^ command_.* = ./{s/ command_//p}'
fi

