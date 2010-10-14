#!/bin/bash
# usage: unpack file [dir]
# info: Unpack file in dir.
lst=("$@")

# directory to unpack files
d=.
if [ $# -gt 1 ]
then
    d=${lst[$#-1]}
	lst=("${lst[0,$#-2]}")
	# create dir
	if ! mkdir -p "$d" 2> /dev/null
	then
		echo -e "usage:\n  $0 file [dir]\n  $0 file1 file2 ... dir"
		exit 1
	fi
fi

for f in "$lst"
do
	if [ -f "$f" ]
	then
        mime=`file --brief --mime "$f"|grep -o '^[^;]\+'`
		case "$mime" in
			application/zip)    CMD="unzip"      ;;
			application/x-rar)  CMD="unrar x"    ;;
			application/x-gzip | application/x-bzip2)
                CMD="tar xvf" ;;
			*)
                       echo "File '$f' cannot be extracted! (mime: '$mime')"
			           exit 1 ;;
		esac

		# filename with full path
		FILE=`readlink -f "$f"`

		# unpack
		(
		echo "$CMD \"$FILE\""
		cd "$d" && eval "$CMD \"$FILE\"" || exit 2
		)
	else
		echo "'$f' is not a valid file!"
		exit 3
	fi
done

