#!/bin/sh
DIR=`dirname $0`
HISTORYFILE="$DIR/runhistory.txt"
RUNHASHFILE="$DIR/runhash.txt"

# update hash on background
#(sleep 1; nice -n 10 "$DIR/dmenu/dmenu-4.0/dmenu_path" > $RUNHASHFILE) &

# command history and PATH
#EXE=$( (cat $HISTORYFILE $RUNHASHFILE) | /home/lukas/dev/menus/menu.sh "RUN:" ) || exit $?
EXE=$( (cat $HISTORYFILE; dmenu_path) | "$DIR/menu.sh" "RUN" ) || exit $?
#EXE=$( (cat $HISTORYFILE; find `echo $PATH | tr : ' '` \! -type d -executable -printf '%f\n' | sort) | "$DIR/menu.sh" "RUN" ) || exit $?
#EXE=$(echo $EXE | sed 's/^ *//;s/ *$//') # remove leading spaces

# handle history
(echo "$EXE"; sed '\#^'"$EXE"'$#{d;q;}' $HISTORYFILE | head -20) > $HISTORYFILE.new
mv $HISTORYFILE.new $HISTORYFILE

# this allows some scripting to be included in command
#(exec echo "$EXE" | /bin/sh ;) &
exec $EXE &

#disown -a && exit

