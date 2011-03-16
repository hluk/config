#!/bin/sh
FILE="$PWD"
FILE=$(
while :
do
    cd "$FILE" 2>/dev/null || break

    FILE=`(echo ../
           find -maxdepth 1 -type d -not -name '.*' -printf '%f/\n' | sort
           find -maxdepth 1 -not -type d -not -name '.*' -printf '%f\n' | sort
           ) |
        sprinter -t"Open file" -l"OPEN:" -g 400,300` ||
            exit 1

    if [ -z "$FILE" ]
    then
        break
    fi

    if [ "$FILE" = "~" ]
    then
        FILE=$HOME
    fi
done
echo $PWD/$FILE
) || exit 1
echo $FILE

CMD=$(find `echo $PATH | tr : ' '` \! -type d -executable -printf '%f\n' |
        sprinter -t"Open file" -l"OPEN WITH:" -o -w -z 196,16 -g 600) ||
            exit 1

exec "$CMD" "$FILE"

