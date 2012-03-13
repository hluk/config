#!/bin/bash
includes=`echo "$@"|grep -o -- '-I\s*\S\+'`
cppcheck --enable=all --force --inline-suppr -q .

