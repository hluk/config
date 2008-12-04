#!/bin/bash
# unpack rar|zip archive to SD card
RARTAG=": RAR archive data"
ZIPTAG=": Zip archive data"
RAROP="unrar x %a %p"
ZIPOP="unzip -q -d %p %a"

for PPCFILE in "$@"
do
	FILETYPE=`file "$PPCFILE" | egrep -o "$RARTAG|$ZIPTAG"`
	if [ "$FILETYPE" = "$RARTAG" ]
	then
		OP=${RAROP/\%a/"\"$PPCFILE\""}
	elif [ "$FILETYPE" = "$ZIPTAG" ]
	then
		OP=${ZIPOP/\%a/"\"$PPCFILE\""}
	else
		echo "ERROR: Unknown file type!"
		continue
	fi

	PPCPATH=`echo "$PPCFILE" | sed -e 's_.*/manga/_/mnt/auto/card/manga/_' -e 's_\....$__'`
	mkdir -p "$PPCPATH"
	eval ${OP/\%p/"\"$PPCPATH\""}
done

echo 'ALL DONE!'
