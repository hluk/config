#!/bin/bash
# Show window selection in Sway Wayland compositor.
set -eo pipefail

swaymsg -t get_tree |
    jq -r '.nodes[].nodes[] | if .nodes then [recurse(.nodes[])] else [] end + .floating_nodes | .[] | select(.nodes==[] and .type=="con") | (.name + " |" + (.id | tostring))' |
        rofi -dmenu | {
            id=$(grep -o '[0-9]*$')
            swaymsg "[con_id=$id]" focus
        }
