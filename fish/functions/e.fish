function e
    if test $TERM = xterm-kitty
        kitty @ launch --type tab --cwd current $EDITOR $argv >/dev/null
    else if test -n $TMUX
        tmux new-window $EDITOR $argv
    else
        $EDITOR $argv
    end
end
