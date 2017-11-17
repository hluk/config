#!/bin/bash
# Runs docker image with access to current X11 session
# allowing to run GUI apps from docker.
xsock=/tmp/.X11-unix
xauth=/tmp/.docker.xauth

touch "$xauth"
xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f "$xauth" nmerge -

docker run -it --rm \
    -e DISPLAY=$DISPLAY \
    -e XAUTHORITY=$xauth \
    -v "$xsock:$xsock" \
    -v "$xauth:$xauth" \
    "$@"
