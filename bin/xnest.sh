D=:${D:-"1"}
Xnest $D -geometry 800x600 &
export DISPLAY=$D

sleep 1
openbox &
#awesome &
#mutter &
#muffin &
sleep 3

"${@:-xterm}"
exit_code=$?

killall Xnest
wait

exit $exit_code

