#!/bin/bash
# exec firefox "$@" &>/dev/null
exec flatpak run io.gitlab.librewolf-community "$@" &>/dev/null
