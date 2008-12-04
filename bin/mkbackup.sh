#!/bin/bash
# backup files or directories into BACKUP_ROOT directory
BACKUP_ROOT="${0%/*}"
DATE=$(date "+%Y%m%d")

for FILE in "$@"
do
	if [ -f "$FILE" ]
	then
		echo "Backing up file \"$FILE\"..."
		FILENAME="${FILE##*/}"
		DIR="${FILE%/*}"
	elif [ -d "$FILE" ]
	then
		echo "Backing up directory \"$FILE\"..."
		FILENAME=$(/bin/ls -d "$FILE" | sed 's_.*/__')
		DIR="$FILE/.."
	else
		echo "File \"$FILE\" doesn't exist!" 1>&2
		exit 1;
	fi

	tar -C "$DIR" -zcf "${BACKUP_ROOT}/${FILENAME}_${DATE}.tgz" "$FILENAME"

	echo "Backup \"${BACKUP_ROOT}/${FILENAME}_${DATE}.tgz\" created."
	echo "DONE"
done
echo "ALL DONE"

