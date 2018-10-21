#!/bin/bash
# Fixes vsync on nvidia.
options=(
    --backend glx
    --vsync opengl-swc
    --unredir-if-possible

    --sw-opti
    --glx-no-stencil
    #--glx-copy-from-front
    #--glx-use-copysubbuffermesa
)
/usr/bin/compton "${options[@]}"
