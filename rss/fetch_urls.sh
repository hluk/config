#!/bin/sh
# allow only one instance of program
PIDFILE="$HOME/fetch_url.pid"
if [ -f "$PIDFILE" ]
then
	OLDPID=`cat "$PIDFILE"`
	(ps -p $OLDPID >/dev/null && echo "Script already running (PID: $OLDPID)!" 1>&2) &&
		exit 1
fi
echo $$ > "$PIDFILE"

#SCRIPTPATH=${0%\/*}
SCRIPTPATH=`dirname "$0"`
LISTDIR="$SCRIPTPATH/lists"
GETPATH="$HOME/dev/wget"

URLS="http://www.gametrailers.com/rssgenerate.php?s1=&vidformat[mov]=on&quality[either]=on&orderby=yespopular&limit=20
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

	mkdir -p "$LISTDIR"

	echo -n "* Fetching rss \"$URL\" ... "
	NEWLIST="`($SCRIPTPATH/rss_urls.sh "$URL" && cat "$OLDLIST") | sort | uniq -u`" &&
		echo "Ok" || (echo "FAILED!"; continue)

	if [ -n "$NEWLIST" ]
	then
		echo "* Downloading new items {{{"

		HOST=`echo "$URL" | grep -oe "http://[^/]*\?"`
		case "$HOST" in
		"http://www.gametrailers.com")
			"$GETPATH/gt_video/gt_video.sh" $NEWLIST || (echo "}}} FAILED!"; exit 1);
			;;
		"http://www.gamersyde.com")
			"$HOME/dev/webdigger/gamersyde.rb" $NEWLIST || (echo "}}} FAILED!"; exit 1);
			;;
		"http://konachan.com")
			"$GETPATH/chan/konachan.sh" $NEWLIST || (echo "}}} FAILED!"; exit 1);
			;;
		"http://moe.imouto.org")
			"$GETPATH/chan/moe.imouto.sh" $NEWLIST || (echo "}}} FAILED!"; exit 1);
			;;
		"http://localhost")
			"$GETPATH/deviantart/deviantart-login.sh" > /dev/null
			"$GETPATH/deviantart/deviantart.sh" $NEWLIST || (echo "}}} FAILED!"; exit 1);
			;;
		"http://{orz.4,img.7}chan.org")
			"$GETPATH/imgboard/imgboard.sh" $NEWLIST || (echo "}}} FAILED!"; exit 1);
			;;
		esac && (
			# remember saved urls (max 200 lines per list)
			(echo "$NEWLIST" && cat "$OLDLIST") | head -n200 > "$OLDLIST.new" &&
				mv "$OLDLIST.new" "$OLDLIST"
			echo "  }}}"
			)
	fi
done

rm -f "$PIDFILE"

TIME=$(($(date '+%s')-TIME))
echo "}}} ALL DONE (in $TIME seconds)"

