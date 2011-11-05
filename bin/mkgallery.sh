#!/bin/bash
# view archive contents (images, videos, fonts)
# use G variable to set gallery name
#G=${G:-default}
G=`zenity --title "New gallery" --entry --text "Gallery name:" --entry-text default` || exit 1
DIR=~/.archives/$G
MKGALLERY=${MKGALLERY:-~/dev/moka/mkgallery/mkgallery.py}
ARGS=${ARGS:-""}

# unpack or mount archives
UNPACK=`dirname "$0"`/unpack.sh
RM="rm -r"
#UNPACK="archivemount -o readonly"
#RM="fusermount -u"

if [ -d "$DIR" ]
then
    zenity --question --text \
        "Gallery in \"$DIR\" already exists. Remove it?" &&
        rm -r "$DIR" || exit 1
fi

FILES=()
TMPDIRS=()
i=0
j=0
for file in "$@"
do
    if file -b "$file"|grep -q archive
    then
        DEST=$DIR/`basename "$file"`
        mkdir -p "$DEST"
        $UNPACK "$file" "$DEST" || exit 1
        TMPDIRS[$((j++))]=$DEST
        FILES[$((i++))]=$DEST
    else
        FILES[$((i++))]=$file
    fi
done
[ -n "$FILES" ] || FILES=(.)

"$MKGALLERY" -u http://localhost:8080/Galleries/%s/ \
    -t ${G:-default} -fp-1 $ARGS \
    "${FILES[@]}"

if [ -n "$TMPDIRS" ]
then
    zenity --question --text "Remove gallery \"$G\"?" &&
        $RM "${TMPDIRS[@]}" && echo "Gallery was removed." && rmdir "$DIR"
fi

