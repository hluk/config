#!/bin/bash
# Fixes vsync on nvidia.
options=(
    --backend glx

    # This solves problems with videos getting stuck momentarily.
    # See https://github.com/chjj/compton/issues/494
    #--backend xr_glx_hybrid

    --vsync opengl-swc
    --unredir-if-possible

    # Minimize flicker when switching windows.
    "--fade-in-step=0.07"
    "--fade-out-step=0.01"
    "--fade-exclude" 'I3_FLOATING_WINDOW@:32c = 1'
    "--fading"

    --sw-opti
    --glx-no-stencil
    --glx-no-rebind-pixmap

    #--glx-copy-from-front
    #--glx-use-copysubbuffermesa
)
pkill compton
exec ~/dev/compton/build/src/compton "${options[@]}"
