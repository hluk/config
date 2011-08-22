D=:${D:-"1"}
Xnest $D &
export DISPLAY=$D
sleep 1
"${@:-xterm}"
killall Xnest
wait

