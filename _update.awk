#!/bin/awk -f
# update all files from LIST
BEGIN {
    gitpath = ENVIRON["PWD"]
}

{
    from = $1
    to = gitpath
    if( $2 ){
        to = to "/" $2
        system("mkdir -p " to)
    }
    system("cp --verbose --update --recursive --dereference " from " " to)
}

