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
	OFILE=${INFILE/.pdf/}
	echo -n "Grabbing images from \"$INFILE\"..."
	# create output directory
	rm -rf "${OFILE}_imgs/"
	mkdir "${OFILE}_imgs" 2> /dev/null
	# convert pdf pages to ppm images
	pdftoppm -f $FIRST -l $LAST "${INFILE}" "${OFILE}_imgs/page" ||
	(echo "FAILED! (pdftoppm -f $FIRST -l $LAST \"${INFILE}\" \"${OFILE}_imgs/page\")"; exit 1) || exit 1

	# convert ppm images to FORMAT
	python -c "
import os, glob, Image, ImageFilter
path = '${OFILE}_imgs/'
files = glob.glob( os.path.join(path, 'page*.ppm') )
files.sort()
for infile in files:
	print 'Converting image ' + infile + ' to $FORMAT...'
	im = Image.open(infile)
	out = im.resize(($RES,int(float($RES*im.size[1])/float(im.size[0]))),Image.ANTIALIAS)
	#out = out.filter(ImageFilter.DETAIL)
	out.save( infile + '.$FORMAT' )
	" && echo "OK" || (echo "FAILED to convert $INFILE!)"; exit 1) || exit 1

	#clean
	rm -f "${OFILE}_imgs/page"*.ppm
done

echo "ALL DONE!"

