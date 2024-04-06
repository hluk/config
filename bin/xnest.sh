#!/bin/bash
set -euo pipefail

D=:${D:-"9"}
#Xnest $D -geometry 800x600 &
#Xnest $D -scrns 2 -geometry 800x600 &
#Xephyr $D -ac -br -reset -terminate +iglx +extension Composite +xinerama -screen 800x600+0+0 -screen 800x600+0+800 &
#Xephyr $D -ac -br -reset -terminate +iglx +extension Composite +extension RANDR -screen 800x600+0+0 -screen 800x600+0+800 &
#Xephyr $D -ac -br -reset -terminate +iglx +extension Composite -screen 5120x1440 &
#Xephyr $D -ac -br -reset -terminate +iglx +extension Composite -screen 640x480 &
Xephyr $D -ac -br -reset -terminate +iglx +extension Composite -screen 1600x900 &
export DISPLAY=$D
export WAYLAND_DISPLAY=
sleep 1

export QT_QPA_PLATFORM=xcb

#herbstluftwm &
openbox &
#awesome &
#xfwm4 &
#i3 &
#mutter --x11 &
#startplasma-x11 &
sleep 1

/usr/libexec/gsd-xsettings &
settings_pid=$!

#xfce4-terminal
#~/dev/build/copyq/debug/install/bin/copyq -s test1
#~/dev/build/copyq/debug/install/bin/copyq &
#~/dev/build/copyq/Qt_5-Debug/copyq tests "$@"
"$@"

kill "$settings_pid"

#cinnamon-settings &
#cinnamon-session
#cinnamon
#lxsession
#xfce4-session
#sleep 3
#"${@:-xterm}"

exit_code=$?

echo "Press Enter to continue..."
read

killall Xnest
killall Xephyr
wait

exit $exit_code

