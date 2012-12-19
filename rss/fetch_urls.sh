#!/bin/bash
# RSS feed URLs
URLS=(
'http://www.gamersyde.com/news_en.rdf'
#'http://konachan.com/post/atom'
#'http://www.gametrailers.com/rssgenerate.php?s1=&vidformat[mov]=on&vidformat[wmv]=on&quality[hd]=on&orderby=curpopular&limit=20'
#'http://moe.imouto.org/post/atom'
#'$HOME/dev/wget/deviantart/deviantart-daily.sh'
)

# prefer URLs passed as arguments
if [ $# -gt 0 ]
then
    URLS=($@)
fi

# allow only one instance
PIDFILE="$HOME/fetch_url.pid"
if [ -f "$PIDFILE" ]
then
	OLDPID=`cat "$PIDFILE"`
	(ps -p $OLDPID >/dev/null && echo "Script already running (PID: $OLDPID)!" 1>&2) &&
		exit 1
fi
echo $$ > "$PIDFILE"

SCRIPTPATH=`dirname "$0"`
LISTDIR="$SCRIPTPATH/lists"
GETPATH="$HOME/dev/wget"

echo -e "\n$(date -R): Fetching urls {{{"
trap 'rm -f '"$PIDFILE"'; echo "}}} FAILED!"; exit 1' TERM QUIT INT

TIME=$(date '+%s')

for URL in ${URLS[@]}
do
	MD5=$(echo "$URL" | md5sum | awk '{print $1; quit;}')
	OLDLIST="$LISTDIR/$MD5.lst"

	mkdir -p "$LISTDIR"
	touch "$LISTDIR/$MD5.lst"

	echo -n "* Fetching rss \"$URL\" ... "
    # $URL is executable file or url to rss
	(test -x "$URL" && "$URL" || $SCRIPTPATH/rss_urls.sh "$URL") > "$OLDLIST.new"

    # find new items
    NEWLIST=`
        while read LINE
        do
            grep -q '^'"$LINE"'$' "$OLDLIST" ||
                echo "$LINE"
        done < "$OLDLIST.new"`
	echo "Done"

	if [ -n "$NEWLIST" ]
	then
		echo "* Downloading new items {{{"

		case "$URL" in
		"http://www.gametrailers.com/"*)
		"$GETPATH/gt_video/gt_video.sh" $NEWLIST || (echo "}}} FAILED!"; exit 1);
		;;

		"http://www.gamersyde.com/"*)
		"$HOME/dev/wget/gamersyde/gamersyde.sh" $NEWLIST || (echo "}}} FAILED!"; exit 1);
		;;

		"http://moe.imouto.org/"* | "http://konachan.com/"* | "http://danbooru.donmai.us/"*)
		"$GETPATH/chan/chan.sh" $NEWLIST || (echo "}}} FAILED!"; exit 1);
		;;

		*"/deviantart-daily.sh")
		"$GETPATH/deviantart/deviantart.sh" $NEWLIST || (echo "}}} FAILED!"; exit 1);
		;;

		"http://{orz.4,img.7}chan.org/"*)
		"$GETPATH/imgboard/imgboard.sh" $NEWLIST || (echo "}}} FAILED!"; exit 1);
		;;

		esac &&
		(
			# remember new urls and max 1000 old
            (cat "$OLDLIST.new"; head -n1000 "$OLDLIST") > "$OLDLIST.tmp" &&
				mv "$OLDLIST.tmp" "$OLDLIST"
			echo "  }}}"
		)
	fi

	rm -f "$OLDLIST.new"
done

rm -f "$PIDFILE"

TIME=$(($(date '+%s')-TIME))
echo "}}} ALL DONE (in $TIME seconds)"

