#!/bin/bash
BOOKMARKSFILE=/home/lukas/.mozilla/firefox/zb0iwrje.default/bookmarks.postplaces.html
MD5FILE=$0.bookmarks.md5

# check hash for faster accsess to menu
md5sum -c "$MD5FILE" > /dev/null

if [ $? -ne 0 ]
then
	egrep '^[ \t]*<DT><A HREF="' "$BOOKMARKSFILE" | sed -e 's/^[ \t]*<DT><A HREF="\([^"]*\)[^>]*>\([^<]*\).*/\2 | \1/' > bookmarks.txt
	md5sum "$BOOKMARKSFILE" > "$MD5FILE"
fi

URL=`(echo "about:blank" | cat - bookmarks.txt) | /home/lukas/dev/menus/menu.sh "URL:"`

if [ $? -eq 0 ]
then
	URL=`echo $URL | sed -e 's/[^|]*| //'`
	exec swiftfox "$URL" &
fi

