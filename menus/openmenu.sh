#!/bin/bash
menu=${menu:-"$HOME/dev/sprinter-gtk/sprinter"}
args=${args:-"-g 460x-1-1-1"}
script=`readlink -f "$0"`

select_files () {
    (
        printf '../\0'
        find -maxdepth 1 -type d -not -name '.*' -printf '%f/\0' | sort -nz
        find -maxdepth 1 -not -type d -not -name '.*' -printf '%f\0' | sort -nz
    ) | "$menu" $args -tOPEN -lOPEN -i'\0' -o'\0' 2>/dev/null
}

cmd () {
    cmd=$(find `echo "$PATH" | tr : ' '` \! -type d -executable -printf '%f\n' |
          "$menu" $args -t"OPEN WITH" -l"OPEN WITH") 2>/dev/null &&
    exec "$cmd" "$@"
}

if [ $# -gt 0 ]
then
    if [ "$*" = "." ]
    then
        cmd .
        exit $?
    fi

    if [ $# -eq 1 ] && cd "$1" 2>/dev/null
    then
        select_files | xargs -0 "$script"
    else
        cmd "$@"
    fi
else
    exit 1
fi

