D=:${D:-"1"}
Xnest $D -geometry 640x400 &
export DISPLAY=$D
sleep 1
"${@:-xterm}"
killall Xnest
wait

