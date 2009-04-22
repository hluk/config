#!/bin/sh
# allow only one instance of program
PIDFILE="$HOME/fetch_url.pid"
if [ -f "$PIDFILE" ]
then
	OLDPID=$(cat "$PIDFILE")
	(ps --no-headers -p $OLDPID > /dev/null && echo -e "Script already running (PID=$OLDPID)!" 1>&2) &&
		exit 1 || rm -f "$PIDFILE"
fi
echo $$ > "$PIDFILE"

SCRIPTPATH=${0%\/*}
LISTDIR="$SCRIPTPATH/lists"
GETPATH="$HOME/dev/wget"

URLS="http://www.gametrailers.com/rssgenerate.php?s1=&vidformat[mov]=on&quality[either]=on&agegate[no]=on&orderby=newest&limit=30
http://www.gamersyde.com/news_en.rdf
http://konachan.com/post/atom
http://moe.imouto.org/post/atom
http://localhost/rss/deviantart-daily.php"
#http://orz.4chan.org/hr/index.rss
#http://img.7chan.org/hr/rss.xml

echo -e "\n$(date -R): Fetching urls {{{"
trap 'rm -f '"$PIDFILE"'; echo "}}} FAILED!"; exit 1' TERM QUIT INT

TIME=$(date '+%s')

for URL in $URLS
do
	#MD5=$(echo "$URL" | md5sum | awk '{print $1; quit;}')
	LISTNAME=$(echo "$URL" | sed 's_^[a-z]*://__;s/[\.\/]/_/g')
	OLDLIST="$LISTDIR/$LISTNAME.lst"
	NEWLIST="$LISTDIR/$LISTNAME.new.lst"
	DIFLIST="$LISTDIR/$LISTNAME.diff.lst"

	mkdir -p "$LISTDIR"

	echo -n "* Fetching rss from \"$URL\" ... "
	$SCRIPTPATH/rss_urls.sh "$URL" | sed 's/^\s*//' | sort > "$NEWLIST" &&
	echo "Ok" || exit 1 || continue

	touch "$OLDLIST"
	diff --old-line-format="" --unchanged-line-format="" --new-line-format='%L' \
		"$OLDLIST" "$NEWLIST" > "$DIFLIST"

	if [ -s "$DIFLIST" ]
	then
		echo "* Downloading new items {{{"

		if [ "$URL" ==  "http://www.gametrailers.com/rssgenerate.php?s1=&vidformat[mov]=on&quality[either]=on&agegate[no]=on&orderby=newest&limit=30" ]
		then
			cat "$DIFLIST" | xargs \
			"$GETPATH/gt_video/gt_video.sh" || (echo "}}} FAILED!"; exit 1)
		elif [ "$URL" == "http://www.gamersyde.com/news_en.rdf" ]
		then
			cat "$DIFLIST" | xargs \
			"$HOME/dev/webdigger/gamersyde.rb" || (echo "}}} FAILED!"; exit 1)
		elif [ "$URL" == "http://konachan.com/post/atom" ]
		then
			cat "$DIFLIST" | xargs \
			"$GETPATH/chan/konachan.sh" || (echo "}}} FAILED!"; exit 1)
		elif [ "$URL" == "http://moe.imouto.org/post/atom" ]
		then
			cat "$DIFLIST" | xargs \
			"$GETPATH/chan/moe.imouto.sh" || (echo "}}} FAILED!"; exit 1)
		elif [ "$URL" == "http://localhost/rss/deviantart-daily.php" ]
		then
			"$GETPATH/deviantart/deviantart-login.sh" > /dev/null
			cat "$DIFLIST" | xargs \
			"$GETPATH/deviantart/deviantart.sh" || (echo "}}} FAILED!"; exit 1)
		elif [ "$URL" == "http://orz.4chan.org/hr/index.rss" -o "$URL" == "http://img.7chan.org/hr/rss.xml" ]
		then
			cat "$DIFLIST" | xargs \
			"$GETPATH/imgboard/imgboard.sh" || (echo "}}} FAILED!"; exit 1)
		fi && (mv "$NEWLIST" "$OLDLIST"; echo "  }}}")
	fi

	rm -f "$NEWLIST" "$DIFLIST"
done

rm -f "$PIDFILE"

TIME=$(($(date '+%s')-TIME))
echo "}}} ALL DONE (in $TIME seconds)"

