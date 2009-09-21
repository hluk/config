#!/bin/sh
DIR="`dirname "$0"`"
TEMP="$DIR/template.html"
OFILE="${1:-$HOME/down/index.html}"
INDEX="`basename "$OFILE"`"
FILES="`find -iregex '.*\.\(jpg\|png\|gif\)' -printf '"%P",\n'|sort`"

# use template to create new html document
(
	sed -n "1,/^\/\/INSERT VARIABLES HERE/{p}" "$TEMP"
	echo "var dir = \"$PWD\"; var index = \"$INDEX\"; var ls = [$FILES];"
	sed -n "/^\/\/INSERT VARIABLES HERE/,\${p}" "$TEMP"
) > "$OFILE"

if [ $? -eq 0 ]
then
	~/chromium.sh "$OFILE" 1>/dev/null &
	disown
else
	exit 1
fi

