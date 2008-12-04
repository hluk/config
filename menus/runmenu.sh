#!/bin/sh
HISTORYFILE=/home/lukas/dev/menus/runhistory.txt
RUNHASHFILE=/home/lukas/dev/menus/runhash.txt

# update hash on background
(sleep 1; nice -n 10 /home/lukas/dev/menus/dmenu-3.4/dmenu_path > $RUNHASHFILE) &
HASHPID=$!

# command history and PATH
EXE=$( (cat $HISTORYFILE $RUNHASHFILE) | /home/lukas/dev/menus/menu.sh "RUN:" ) || exit $?
EXE=$(echo $EXE | sed 's/^ *//;s/ *$//') # remove leading spaces

# handle history
(echo "$EXE"; sed '\#^'"$EXE"'$#{d;q;}' $HISTORYFILE | head -20) > $HISTORYFILE.new
mv $HISTORYFILE.new $HISTORYFILE

# this allows some scripting to be included in command
exec echo "$EXE" | /bin/sh ;

wait $HASHPID

