D=:${D:-"1"}
Xnest $D -geometry 800x600 &
export DISPLAY=$D
sleep 1
"${@:-xterm}"
killall Xnest
wait

