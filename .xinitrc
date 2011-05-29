#!/bin/sh
~/autoconf.sh &

echo ".xinit: starting redshift"
~/dev/bin/redshift.sh &

echo ".xinit: starting Wicd"
(killall wicd-client; wicd-client) &

echo ".xinit: starting CopyQ"
~/dev/copyq-build/release/copyq &

echo ".xinit: setting mouse pointer theme"
( xrdb -merge ~/.Xresources && xsetroot -cursor_name arrow ) &

# simple web server on port 8080
echo ".xinit: starting webserver on port 8080"
(cd ~/www && python -m http.server 8080 2>&1 >/dev/null) &

#echo ".xinit: starting LXDE"
#exec ck-launch-session startlxde

#echo ".xinit: starting window manager"
#while :; do ~/wm; done

export INTEL_BATCH=1
export LAUNCH_CONDITION="pidof X"
~/launch.sh compiz --sm-disable --indirect-rendering --replace ccp &
~/launch.sh trayer --align right --transparent true --tint black --alpha 48 --width 140 --widthtype pixel &
~/launch.sh cairo-dock

