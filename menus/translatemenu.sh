#!/bin/sh
SCRIPT_PATH=$HOME/dev/menus
TLANG=$(echo 'en--cz
cz--en
text' | /home/lukas/dev/menus/menu.sh "DICTIONARY:") || exit $?

if [ "$TLANG" == "text" ]
then
	TEXT=$(kdialog --textinputbox "Translate:" | python $HOME/dev/translate/translate.pyo -f en -t cz) || exit $?
	if [ -n "$TEXT" ]
	then
		kdialog --geometry 640x512 --textinputbox "Translation:" "$TEXT"
	fi
	exit $?
fi

WORDS=$(cat "$SCRIPT_PATH/translated_$TLANG.txt" | /home/lukas/dev/menus/menu.sh "$TLANG:") || exit $?
WORDS=$(echo $WORDS | sed 's/^[ ]*//;s/[ ]*$//')
WORD=$(echo $WORDS | sed -n '/ /p')
if [ -n "$WORD" ]
then
	TEXT="$(python $HOME/dev/translate/translate.pyo -f ${TLANG/--*/} -t ${TLANG/*--/} "$WORD")

" || exit $?
fi

TEXT=${TEXT}$(python $HOME/dev/translate/translate.pyo -f ${TLANG/--*/} -t ${TLANG/*--/} $WORDS) || exit $?

#kdialog --geometry 480x480 --textinputbox "Translation:" "$TEXT"
urxvtc -name rxvtpopup -geometry 60x60+780+50 -e /bin/sh -c "echo \"$TEXT\";read"

(cd "$SCRIPT_PATH" &&
(cp translated_$TLANG.txt translated_$TLANG.txt.old || touch translated_$TLANG.txt.old) &&
echo "$WORDS" | sed 's/[ ][ ]*/\n/g' | sort -b -f > translated_$TLANG.txt.new &&
sort -b -f -u -m translated_$TLANG.txt.new translated_$TLANG.txt.old > translated_$TLANG.txt &&
rm -f translated_$TLANG.txt.{new,old}) || exit $?

