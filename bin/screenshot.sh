#!/bin/bash
set -e

image=$(mktemp "/tmp/screenshot-$USER-XXX.png")
cleanup() {
    rm -rf -- "$image"
}
trap cleanup QUIT TERM INT HUP EXIT
grim -t png -c "$image"
krita "$image"
