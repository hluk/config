#!/bin/bash
grim -g "$(slurp)" - | swappy -f -

#export XDG_CURRENT_DESKTOP=sway
#export QT_QPA_PLATFORM=
#exec ~/dev/build/flameshot/src/flameshot "$@"
