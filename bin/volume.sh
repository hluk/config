#!/bin/bash
# print usage
if [ $# == 0 ]
then
	echo \
	"Usage: $0 N%[+-]
       $0 5%+   # Volume up 5%
       $0 5%-   # Volume down 5%"
	exit 1
fi

# view changed volume
amixer set Master $1
amixer set Speaker $1
amixer set PCM $1

