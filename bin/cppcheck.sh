#!/bin/bash
cppcheck --enable=all --force --inline-suppr -q -I include "$@" .
