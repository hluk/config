#!/bin/sh
DIR=`dirname "$0"`
CMD=`tac ~/.histfile | uniq | "$DIR/menu.sh"` || exit 1
export CMD
echo "$CMD" >> ~/.histfile
exec xterm -title "COMMAND: $CMD" -e '(echo "$CMD";cat) | "$SHELL"'

