#!/bin/bash
# file: protagonize.sh
# download story from from www.baka-tsuki.net
if [ $# != 1 ]
then
        echo 'Specify rss feed of story.'
        exit 1
fi

TMP=`mktemp` || exit 1
trap "rm -f $TMP" EXIT
trap "rm -f $TMP; exit 1" INT TERM QUIT

wget -q -O $TMP "$1"

TITLE=`sed -n '/^[ ]*<description>/{s/[^'\'']*'\''//;s/'\''.*//;p;q}' $TMP`
DIR="Story - $TITLE"

mkdir -p "$DIR"

URLS=(`sed -n '/^[ ]*<link>/{s/.*<link>//;s/<\/link>.*//p}' $TMP`)
CHAPS=(`sed -n '/^[ ]*<title>/{s/.*<title>//;s/ (chapter in story .*\|<\/title>.*//;s/ /_/g;s/[!?<>*]//g;p}' $TMP | head -n-2`)

NUM=${#CHAPS[@]}
for COUNT in $(seq 0 $(($NUM-1)))
do
	FILENAME="`printf %03d $((NUM-COUNT)) | sed 's/[\\\|\/\:\?\"\*\<\>]/_/g'`_${CHAPS[$COUNT]}.html"
	if [ -f "$DIR/$FILENAME" ]
	then
		echo "File \"$FILENAME\" already exists."
	else
		wget -nv -O "$DIR/$FILENAME.part" "${URLS[$COUNT]}" || exit 1

		# replace "next chapter" link
		if [ -n "$OLDFILENAME" ]
		then
			sed '/href="\/story\/[^"\/]*\/[0-9]\+"/{s/\/story\/[^"\/]*\/[0-9]\+/'"$OLDFILENAME"'/;q}' \
				"$DIR/$FILENAME.part" > "$DIR/$FILENAME"
			rm -f "$DIR/$FILENAME.part"
		else
			mv "$DIR/$FILENAME.part" "$DIR/$FILENAME"
		fi

		OLDFILENAME=$FILENAME
	fi
done

# create zip file
rm -f "$DIR.zip"
zip -r "$DIR.zip" "$DIR"

