function gl
    git la --color -$LINES | head -$(math $LINES - 5)
end
