#!/bin/bash
# right way for export Xauthority file
xauth extract /srv/chroot/wheezy/$HOME/.Xauthority $DISPLAY
# run your command
schroot -c wheezy
# remove the Xauthority
rm -f /srv/chroot/wheezy/$HOME/.Xauthority

