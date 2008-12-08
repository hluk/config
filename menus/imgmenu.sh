#!/bin/sh
HISTORYFILE=/home/lukas/dev/menus/imghistory.txt

# command history and PATH
EXE=$( (cat $HISTORYFILE; cd $HOME/Pictures && find * -maxdepth 1 -type d) | $HOME/dev/menus/menu.sh "Select directory:" ) || exit $?

# handle history
(echo "$EXE"; sed '\#^'"$EXE"'$#{d;q;}' $HISTORYFILE | head -20) > $HISTORYFILE.new
mv $HISTORYFILE.new $HISTORYFILE

echo "$EXE"

