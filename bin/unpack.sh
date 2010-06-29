#!/bin/bash
# usage: unpack file [dir]
# info: Unpack file in dir.
lst=($@)

# directory to unpack files
d=.
if [ $# -gt 1 ]
then
	d=${@[$#]}
	lst=(${@[1,$((#-1))]})
	# create dir
	if ! mkdir -p "$d" 2> /dev/null
	then
		echo -e "usage:\n  $0 file [dir]\n  $0 file1 file2 ... dir"
		exit 1
	fi
fi

for f in $lst
do
	if [ -f "$f" ]
	then
		case "$f" in
			*.tar)     CMD="tar xvf"    ;;
			*.tbz2)    CMD="tar xvjf"   ;;
			*.tgz)     CMD="tar xvzf"   ;;
			*.tar.*)   CMD="tar xvf"    ;;
			*.bz2)     CMD="bunzip2"    ;;
			*.rar)     CMD="unrar x"    ;;
			*.gz)      CMD="gunzip"     ;;
			*.zip)     CMD="unzip"      ;;
			*.Z)       CMD="uncompress" ;;
			*.7z)      CMD="7z x"       ;;
			*)
			echo "File '$f' cannot be extracted!"
			exit 1
			;;
		esac

		# filename with full path
		FILE=`readlink -f "$f"`

		# unpack
		(
		echo "$CMD \"$FILE\""
		cd "$d" && eval "$CMD \"$FILE\"" || exit 2
		)
	else
		echo "'$f' is not a valid file"
		exit 3
	fi
done

