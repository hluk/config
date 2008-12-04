#!/bin/awk -f
# update all files from LIST
BEGIN {
	gitpath = ENVIRON["HOME"]"/dev/config"
}

{
	from = $1
	to = gitpath
	if( $2 ){
		to = to "/" $2
		system("mkdir -p " to)
	}
	system("cp --recursive --dereference " from " " to)
}

