#!/bin/bash
FILE="$PWD"

select_files () {
    (
        printf '../\0'
        find -maxdepth 1 -type d -not -name '.*' -printf '%f/\0' | sort -nz
        find -maxdepth 1 -not -type d -not -name '.*' -printf '%f\0' | sort -nz
    ) | $MENU -tOPEN -lOPEN -i'\0' -o'\0'
}

cmd () {
    CMD=$(find `echo $PATH | tr : ' '` \! -type d -executable -printf '%f\n' |
          $MENU -t"OPEN WITH" -l"OPEN WITH") || exit 1
    exec "$CMD" "$@"
}

if [ $# -gt 0 ]
then
    if [ "$&" = "" ]
    then
        exit 1
    elif [ "$&" = "." ]
    then
        cmd . && exit || exit 1
    fi

    if test $# -eq 1 && cd "$1" 2>/dev/null
    then
        select_files | xargs -0 "$0"
    else
        cmd "$@"
    fi
else
    test -z "$MENU" || exit 1
    export MENU="$HOME/dev/sprinter-gtk/sprinter -g 400x-64-1-1"
    printf "$FILE" | xargs -0 "$0"
fi

