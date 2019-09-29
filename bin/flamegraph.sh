#!/bin/bash
# Creates flamegraph from perf profile.
# Uses https://github.com/brendangregg/FlameGraph
set -exuo pipefail

flamegraph=${FLAMEGRAPH:-~/dev/FlameGraph/}
browser=${BROWSER:-firefox}
frequency=${FREQUENCY:-99}
width=${WIDTH:-2000}

perf_samples="perf_samples.svg"

record() {
    perf record -g --call-graph dwarf -F "$frequency" -- "$@"
}

create_flamegraph() {
    perf script |
        "$flamegraph/stackcollapse-perf.pl" |
        "$flamegraph/flamegraph.pl" --width "$width" > "$perf_samples"
}

show_flamegraph() {
    "$browser" "$perf_samples"
}

if [[ $# -gt 1 ]]; then
    record "$@"
fi

create_flamegraph
show_flamegraph

