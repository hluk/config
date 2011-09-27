#!/bin/bash
# view archive contents (images, videos, fonts)
# use G variable to set gallery name
DIR=~/.archives/${G:-default}
#MKGALLERY=${MKGALLERY:-~/dev/gallery/mkgallery.py}
MKGALLERY=${MKGALLERY:-~/dev/moka/mkgallery/mkgallery.py}
UNPACK=`dirname "$0"`/unpack.sh

FILES=()
i=0
for archive in "$@"
do
    DEST=`basename "$archive"`
    "$UNPACK" "$archive" "$DIR/$DEST" || exit 1
    FILES[$((i++))]="$DEST"
done
[ -n "$FILES" ] || exit 1

(
cd "$DIR" &&
"$MKGALLERY" -u http://localhost:8080/Galleries/%s/ -t ${G:-default} -fp-1 \
    "${FILES[@]}"

zenity --question --text "Remove gallery \"$G\"?" &&
    printf "$FILES" | xargs -0 rm -r && echo "Files deleted." && rmdir "$DIR"
)

