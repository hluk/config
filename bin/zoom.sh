#!/bin/bash
# Scales text in desktop environment (work in Firefox).
set -euo pipefail

default_scale=1.5

zoom() {
    echo "Zooming to $1"
    gsettings set org.gnome.desktop.interface text-scaling-factor "$1"
}

if [[ $# -gt 0 ]]; then
    zoom "$1"
    exit
fi

current_scale=$(gsettings get org.gnome.desktop.interface text-scaling-factor)

if [[ $current_scale == 1.0 ]]; then
    zoom $default_scale
else
    zoom 1
fi
