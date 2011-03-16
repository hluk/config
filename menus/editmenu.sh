#!/bin/sh
DIR=`dirname $0`
# files from history (run echo in shell for tilde expantion)
FILES=`sed -nr 's/^> /echo /p' ~/.viminfo | sh | "$DIR/menu.sh" EDIT:` || exit 1
echo "$FILES" |
# run editor (files in vertical split view)
xargs gvim -O
# run editor (files in tabs)
#xargs gvim -p

