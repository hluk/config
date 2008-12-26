#!/bin/bash
# file: protagonize.sh
# download story from from protagonize.com
if [ $# -lt 1 ]
then
        echo 'Specify story url.'
        exit 1
fi

# get title
TITLE=`echo "$1" | sed 's_.*www.protagonize.com/story/__;s_/.*__;q'`
FILENAME=`echo "$1" | sed 's_.*/\([^/]*\)_\1_;q'`.html
if [ -z "$TITLE" -o -z "$FILENAME" ]
then
	echo "ERROR: Bad url ($1)!"
	exit 2
fi

if [ -z "$CHLEVEL" ]
then
	# create directory
	DIR="Story - $TITLE"
	echo "INFO: Creating \"$DIR\""
	mkdir -p "$DIR"

	# reset CHAPTER LEVEL
	CHLEVEL=0
fi

# increase chapter level
CHLEVEL=$((CHLEVEL + 1))
echo "INFO: chapter level $CHLEVEL ($1)"

# download file if it does not exists
TMP="$DIR/$FILENAME".tmp
wget -q -O "$DIR/$FILENAME" "$1" ||
	echo "ERROR: Cannot download \"$1\"" && exit 3
cp "$DIR/$FILENAME" "$TMP" 

# get next chapters into array (parenthesis)
URLS=(`grep -o '<a id="ctl[0-9]*_columnLeft_ctlStoryDetail_rptBranches_ctl[0-9]*_hypBranch"[^>]*' "$TMP" | sed 's/.*href="\([^"]*\)".*/\1/'`) ||
	echo "INFO: No other chapters found" 

# save current story chapter
cat "$TMP" | sed 's_"/story/'"${TITLE}"'/\([^"]*\)"_"\1.html"_g' > "$DIR/$FILENAME"
rm "$TMP"

NUM=${#URLS[@]}
for COUNT in $(seq 0 $((NUM-1)))
do
	# recursively download all chapters
	DIR="$DIR" CHLEVEL=$CHLEVEL $0 "http://www.protagonize.com/${URLS[$COUNT]}" || exit $?
done

# create zip file if everything downloaded
if [ "$CHLEVEL" == "1" ]
then
	rm -f "$DIR.zip"
	zip -r "$DIR.zip" "$DIR"
fi

