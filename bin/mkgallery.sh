#!/bin/bash
# view archive contents (images, videos, fonts)
# use G variable to set gallery name
#G=${G:-default}
G=`zenity --title "New gallery" --entry --text "Gallery name:" --entry-text default` || exit 1
DIR=~/.archives/$G
MKGALLERY=${MKGALLERY:-~/dev/moka/mkgallery/mkgallery.py}

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
i=0
for archive in "$@"
do
    DEST=`basename "$archive"`
    mkdir -p  "$DIR/$DEST"
    $UNPACK "$archive" "$DIR/$DEST" || exit 1
    FILES[$((i++))]="$DEST"
done
[ -n "$FILES" ] || exit 1

(
cd "$DIR" &&
"$MKGALLERY" -u http://localhost:8080/Galleries/%s/ -t ${G:-default} -fp-1 \
    "${FILES[@]}"

zenity --question --text "Remove gallery \"$G\"?" &&
    $RM "${FILES[@]}" && echo "Gallery was removed." && rmdir "$DIR"
)

