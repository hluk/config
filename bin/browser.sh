#!/bin/bash
if [[ $XDG_SESSION_TYPE == "x11" ]]; then
    exec firefox "$@" &>/dev/null
else
    exec firefox-wayland "$@" &>/dev/null
fi
