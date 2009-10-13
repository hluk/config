#!/bin/sh
# Simple Javascript/HTML image viewer
# + mouse drag scrolling
# + zooming (in/out/fit to window/fill window/actual size)
# + keyboard navigation
#
# usage: mkgallery.sh [file.html]

DIR="`dirname "$0"`"
TEMP="$DIR/template.html"
INDEX="${1:-index.html}"
FILES="`find -iregex '.*\.\(jpg\|png\|gif\)' -printf '"%P",\n'|sort`"

# use template to create new html document
(
	sed -n "1,/^\/\/<BEGIN>/{/^\/\//!{p}}" "$TEMP"
	echo "var ls = [$FILES];"
	sed -n "/^\/\/<END>/,\${/^\/\//!{p}}" "$TEMP"
) > "$INDEX"

if [ $? -eq 0 ]
then
	# open image viewer in BROWSER
	if [ -n "$BROWSER" ]
	then
		"$BROWSER" "file://$PWD/$INDEX" 1>/dev/null &
		disown
	fi
else
	exit 1
fi

