#!/bin/bash
if [ $# -eq 0 ]
then
	echo "Create zip file with pictures at most NUM days old."
	echo "USAGE: $0 NUM"
	exit 1
fi

(rm -f obrazky.zip &&
cd $HOME/Pictures &&
find . -cmin -$((60*24*$1)) -and -not \( \
	-wholename './anime/*' -or -wholename './Magic the Gathering/*' -or -name obrazky.sh \) \
	-and -not -type d -print0 | xargs -0 zip images.zip) || exit 2

