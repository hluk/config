#!/bin/sh
# Simple Javascript/HTML image viewer
#
# usage: mkgallery.sh [gallery_name]
#
# description:
#   View image files from current directory (recursively)
#   in default web browser (BROWSER environment variable).
#
# features:
# + mouse drag scrolling
# + zooming (in/out/fit to window/fill window/actual size)
# + keyboard navigation
#

DIR="`dirname "$0"`"
GDIR="$DIR/galleries/${1:-default}"
TEMP="$DIR/template.html"

mkdir -p "$GDIR" &&
ln -fsT "$PWD" "$GDIR/imgs" || exit 1
FILES="`cd "$GDIR" && find imgs/ -iregex '.*\.\(jpg\|png\|gif\)' -printf '"%P",\n'|sort`"

# use template to create new html document
(
	sed -n "1,/^\/\/<BEGIN>/{/^\/\//!{p}}" "$TEMP"
	echo "var ls = [$FILES];"
	sed -n "/^\/\/<END>/,\${/^\/\//!{p}}" "$TEMP"
) > "$GDIR/index.html"

if [ $? -eq 0 ]
then
	# open image viewer in BROWSER
	if [ -n "$BROWSER" ]
	then
		"$BROWSER" "file://$GDIR/index.html" 1>/dev/null &
		disown
	fi
else
	exit 1
fi

