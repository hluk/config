#!/bin/bash
# generate pch/ dir with clang
pch_path="pch"

set -e

mkdir -p "$pch_path"

dir=$1
shift

base="$pch_path/`basename $dir`"
pch="$base.pch"
header="$base.h"
find "$dir" -name "*.h" | sed 's/.*/#include <&>/' > "$header"
clang "$@" -I . -x c++-header "$header" -fno-exceptions -fgnu-runtime -o "$pch"

