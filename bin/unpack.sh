#!/bin/bash
# usage: unpack file ... [dir]
# info: Unpack file in dir.
USAGE=$(cat <<EOF
Usage:
  $0 file ... [dir]
  Directory name "dir" can contain "%d" ("%02d" or similar)
  which will be replaced by archive sequence number.
EOF
)

if [ $# -eq 0 ]
then
    echo "$USAGE"
    exit 0
fi

lst=("$@")

# directory to unpack files
dd=.
if [ $# -gt 1 ]
then
    dd=${lst[$#-1]}
    if [ ! -f "$d" ]
    then
        lst=("${lst[@]::$#-1}")
    else
        dd=.
	fi
fi

i=0
for f in "${lst[@]}"
do
    # create dir
    i=$((i+1))
    d=`printf "$dd" $i`
    if ! mkdir -p "$d" # 2> /dev/null
    then
        echo "$USAGE"
        exit 1
    fi

    f=`readlink -f "$f"`
	if [ -f "$f" ]
	then
        mime=`file --brief --mime-type "$f"`
		case "$mime" in
			application/zip)    CMD="unzip"      ;;
			application/x-rar)  CMD="unrar x"    ;;
            application/x-xz)   CMD="tar xJvf"   ;;
			application/x-tar | application/x-gzip | application/x-bzip2)
                CMD="tar xvf" ;;
            application/x-7z-compressed|application/octet-stream) CMD="7z x" ;;
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

