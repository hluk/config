#!/bin/bash
# generate tags file for C and C++
find "$@" -regex ".*\.\(c\|h\|hpp\|cc\|cpp\)" |
    ctags --totals -R \
        --fields=+il --c-kinds=+p --c++-kinds=+p --extra=+q \
        -L -

