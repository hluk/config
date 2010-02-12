#!/bin/sh
# Saves pdf document pages in some image format
RES=${RES:-1024}	# set resolution here
FORMAT=${FORMAT:-jpg}	# set jpeg quality
QUALITY=${QUALITY:-75}	# set jpeg quality
FIRST=${FIRST:-0}	# first page
LAST=${LAST:-0}		# last page

if [ -z "$1" ]
then
	echo "usage: $0 pdf_file(s)"
fi

for INFILE in "$@"
do
	OFILE="${INFILE/.pdf/}"
	echo -n "Grabbing images from \"$INFILE\"..."
	# create output directory
	rm -rf "${OFILE}_imgs/"
	mkdir "${OFILE}_imgs" 2> /dev/null
	# convert pdf pages to ppm images
	pdftoppm -f $FIRST -l $LAST "${INFILE}" "${OFILE}_imgs/page" ||
	(echo "FAILED! (pdftoppm -f $FIRST -l $LAST \"${INFILE}\" \"${OFILE}_imgs/page\")"; exit 1) || exit 1

	# convert ppm images to FORMAT
    (
    cd "${OFILE}_imgs" &&
    for x in *.ppm
    do
	    echo "Converting image $x to $FORMAT..."
        convert "$x" -trim -resize "$RES" -quality $QUALITY "$x.$FORMAT" &&
        echo "OK" || (echo "FAILED"; exit 1) || exit 1
    done
    ) || exit 1
	#clean
	rm -f "${OFILE}_imgs/page"*.ppm
done

echo "ALL DONE!"

