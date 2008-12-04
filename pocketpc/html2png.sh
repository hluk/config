#!/bin/sh
if [ -z "$1" ]
then
	echo "Usage: $0 html_files"
	exit 1
fi

for HTML in "$@"
do
	echo "Coverting html \"$HTML\" to pdf ..."
	sed 's_/\*[^\*]*\*/__g' "$HTML" | sed 's/[‘’]/'\''/g;s/[“”]/"/g;s/…/.../g;s/—/-/g' |iconv -c -t utf8 -t iso8859-1 |
	htmldoc --pagemode fullscreen --webpage --size 93x70mm \
		--headfootsize 0mm --bottom 0mm --top 0mm --left 0mm --right 0mm \
		--bodycolor black --textcolor white --linkcolor white \
		--textfont helvetica --fontsize 11 --fontspacing 1 \
		--headfootfont monospace --header "h /" --footer "h /" \
		-f "$HTML.pdf" - #|| exit $?

	echo "Creating images from pdf ..."
	RES=960 FORMAT=png /home/lukas/dev/pdf/pdf2img.sh "$HTML.pdf" || (echo "FAILED!"; exit 1) || exit 1
	echo "DONE!"
done
echo "ALL DONE!"

