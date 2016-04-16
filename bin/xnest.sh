D=:${D:-"1"}
Xnest $D -geometry 1200x800 &
export DISPLAY=$D

sleep 1
#awesome &
#mutter &
#muffin &

#cinnamon-settings &
#cinnamon-session
lxsession
#sleep 3
#"${@:-xterm}"

exit_code=$?

echo "Press Enter to continue..."
read

killall Xnest
wait

exit $exit_code

