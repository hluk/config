#!/bin/bash
# browse images given as parameter or images in current directory
test $# -eq 0 && ARGS=. || ARGS=("$@")

# THUMBS != "" => thumbnail mode
THUMBS=${THUMBS:-}
FONT="$HOME/dev/magic/font/ --font MatrixB_cs/13"
#FONT="$HOME/.fonts/ --font Fertigo_PRO.otf/11"

if [ -n "$THUMBS" ]
then
	ARG="--fontpath $FONT -t -y 320 -E 320 -W 1950"
else
	ARG="-F"
fi

# ACTIONS
# 1) move to selected picture directory
ACTION1='
	PIC_ROOT=$HOME/Pictures
	DEST=$($HOME/dev/menus/imgmenu.sh) || exit 1
	test -n "$DEST" && mv "%f" "$PIC_ROOT/$DEST/"
	'
# 2) open with firefox (for animated gif)
ACTION2='
	firefox "%f"
	'
# 3) det as wallpaper
ACTION3='
	$HOME/dev/img/set_wallpaper.sh "%f"
	'
# 9) delete file
ACTION9='
	(echo -e "yes\nno" | ~/dev/menus/menu.sh "DELETE \"%f\"?" | xargs test yes \=) && rm -f "%f"
	'

# COMMAND LINE
feh $ARG -S filename --action1 "$ACTION1" --action2 "$ACTION2" --action3 "$ACTION3" --action9 "$ACTION9" "${ARGS[@]}" > /dev/null 2>&1 &

