#!/bin/bash
# ./gconf-shortcut.sh 1 /home/lukas/dev/bin/console.sh '<Mod4>Q'
# ./gconf-shortcut.sh 2 /home/lukas/dev/bin/browser.sh '<Mod4>W'
# ./gconf-shortcut.sh 3 "/home/lukas/dev/bin/red.sh +100" '<Mod4>Right'
# ./gconf-shortcut.sh 4 "/home/lukas/dev/bin/red.sh -100" '<Mod4>Left'
if [ $# -eq 3 ]; then
    gconftool-2 \
        -s /apps/metacity/keybinding_commands/command_"$1" --type=string "$2"  \
        -s /apps/metacity/global_keybindings/run_command_"$1" --type=string "$3"
elif [ $# -eq 2 ]; then
    gconftool-2 \
        -u /apps/metacity/keybinding_commands/command_"$1" \
        -u /apps/metacity/global_keybindings/run_command_"$1"
elif [ $# -eq 1 ]; then
    gconftool-2 \
        -g /apps/metacity/keybinding_commands/command_"$1" \
        -g /apps/metacity/global_keybindings/run_command_"$1"
else
    gconftool-2 -R /apps/metacity/keybinding_commands|sed -n '/^ command_.* = ./{s/ command_//p}'
fi

