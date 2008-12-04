#!/bin/sh
SCRIPT_PATH=$HOME/dev/menus

CMD=$(echo ": " | cat - "$HOME/.viminfo" | sed -n '/^:/p' | /home/lukas/dev/menus/menu.sh "vim:") || exit $?

(cd $HOME && gvim --cmd "$CMD") || exit $?

