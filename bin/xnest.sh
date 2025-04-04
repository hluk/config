#!/bin/bash
set -euo pipefail

D=:${D:-"9"}
#Xnest $D -geometry 800x600 &
#Xnest $D -scrns 2 -geometry 800x600 &
#Xephyr $D -ac -br -reset -terminate +iglx +extension Composite +xinerama -screen 800x600+0+0 -screen 800x600+0+800 &
#Xephyr $D -ac -br -reset -terminate +iglx +extension Composite +extension RANDR -screen 800x600+0+0 -screen 800x600+0+800 &
#Xephyr $D -ac -br -reset -terminate +iglx +extension Composite -screen 5120x1440 &
#Xephyr $D -ac -br -reset -terminate +iglx +extension Composite -screen 640x480 &
# Xephyr $D -ac -br -reset -terminate +iglx +extension Composite -screen 3840x2160 &
Xephyr $D -ac -br -reset -terminate +iglx +extension Composite -screen 1600x900 &
x_pid=$!
# trap "kill $x_pid || true" QUIT TERM INT HUP EXIT
export DISPLAY=$D
export WAYLAND_DISPLAY=
sleep 1

export QT_QPA_PLATFORM=xcb

openbox &
#herbstluftwm &
#awesome &
#xfwm4 &
#i3 &
#mutter --x11 &
#startplasma-x11 &
sleep 1

/usr/libexec/gsd-xsettings &
settings_pid=$!
trap "kill $settings_pid || true" QUIT TERM INT HUP EXIT

#xfce4-terminal
#~/dev/build/copyq/debug/install/bin/copyq -s test1
#~/dev/build/copyq/debug/install/bin/copyq &
#~/dev/build/copyq/Qt_5-Debug/copyq tests "$@"
"$@"

#cinnamon-settings &
#cinnamon-session
#cinnamon
#lxsession
#xfce4-session
#sleep 3
#"${@:-xterm}"

exit_code=$?

exit $exit_code
