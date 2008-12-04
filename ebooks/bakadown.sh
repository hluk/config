#!/bin/bash
# file: bakadown.sh
# download light novel from www.baka-tsuki.net
FORMAT=${FORMAT:-'http://www.baka-tsuki.net/project/index.php?title=<N>:Volume<V>_Chapter<C>&printable=yes'}

if [ $# != 3 ]
then
        echo 'Specify novel name, volume and number of chapters.'
        echo 'You can define FORMAT environment variable. Default:'
        echo "  'http://www.baka-tsuki.net/project/index.php?title=<N>:Volume<V>_Chapter<C>&printable=yes'"
        exit 1
fi

# download chapters with images to NAME_VOLUME directory
DIR="$1"_"$2"
mkdir -p "$DIR"

URL_V="`echo "$FORMAT" | sed "s/<N>/$1/;s/<V>/$2/"`"
for X in `seq 1 $3`
do
        URL_C="`echo "$URL_V" | sed "s/<C>/$X/"`"
        wget -P "$DIR" -nH --cut-dirs=1 -pk -nc --restrict-file-names=windows "$URL_C" || break
done

# rename html files
for X in `(cd "$DIR" && file -iF' ' * | sed -n '/text\/html/{s/  text\/html$//p}')`
do
        NAME=`echo "$X" | sed 's/^index.php@title=//;s/%[0-9A-F]\{2\}/-/g'`
        mv "$DIR/$X" "$DIR/$NAME.html"
done

rm -f "$DIR/"*.html.html "$DIR/robots.txt" "$DIR/favicon.ico" "$DIR/index.php@title=-&action=raw&gen=js"

# create zip file
rm -f "$DIR.zip"
zip -r "$DIR.zip" "$DIR"

