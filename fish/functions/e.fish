function e
    if test -n $TMUX
        tmux new-window $EDITOR $argv
    else
        $EDITOR $argv
    end
end
