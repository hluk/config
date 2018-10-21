#!/bin/bash
# Fixes vsync on nvidia.
options=(
    --backend glx
    --vsync opengl-swc
    --unredir-if-possible

    # Minimize flicker when switching windows.
    "--fade-in-step=0.07"
    "--fade-out-step=0.01"
    "--fading"
    #"--no-fading-openclose"

    --sw-opti
    --glx-no-stencil
    #--glx-copy-from-front
    #--glx-use-copysubbuffermesa
)
pkill compton
/usr/bin/compton "${options[@]}"
