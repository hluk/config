function reflog -a i
    set prev (math $i - 1)
    git diff "HEAD@{$i}".."HEAD@{$prev}"
end
