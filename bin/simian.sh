#!/bin/bash
options=(
-ignoreCharacters
-ignoreCurlyBraces
-ignoreLiterals
-ignoreModifiers
-ignoreNumbers
-ignoreOverlappingBlocks
-ignoreRegions
-ignoreStrings
-ignoreSubtypeNames
-ignoreVariableNames
-language=C++
-reportDuplicateText
-threshold=5
)

run () {
    for dir in "$@"; do
        ( cd "$dir" && simian "${options[@]}" **/*.cpp )
    done
}

if [ $# -eq 0 ]; then
    run .
else
    run "$@"
fi

