#!/bin/bash
# usage:
#   ./set_wallpaper.sh # sets random wallpaper from WALLPATH env or ~/wallpapers
#   ./set_wallpaper.sh image_file
set -o errexit
set -o nounset
set -o pipefail

# redirect output to LOGFILE
exec 1> ~/wallpaper.log

WALLPATH=${WALLPATH:-"$HOME/wallpapers"}

# screen resolution
#RES=(1920 1080)
RES=(3840 2160)

CACHE_PATH="$WALLPATH/.tmp"
TMP="$HOME/.wallpaper.tmp.jpg"

if [[ ! -d "$WALLPATH" ]]; then
    echo "Wallpaper directory \"$WALLPATH\" does not exist. Setting empty wallpaper."
    feh --bg-fill "/usr/share/wallpapers/Next/contents/images/${RES[0]}x${RES[1]}.png"
    exit
fi

remove_tmp() {
    rm -rf "$TMP"
}
trap remove_tmp EXIT

trap 'echo "FAILED!"; exit 1' TERM QUIT INT

# take image as parameter or random image from WALLPATH
IMG="${1:-}"
if [ -n "$IMG" ]; then
    echo "$(date -R): Setting wallpaper \"$IMG\""
    if /usr/bin/curl -s -o "$TMP" "$1"; then
        IMG="$TMP"
    fi
else
    IMG="$(find -L "$WALLPATH"/* -type f | shuf | head -1)"
    echo "$(date -R): Setting random wallpaper \"$IMG\""
fi

CACHE_PATH="$CACHE_PATH/${RES[0]}x${RES[1]}"
# create wallapaper if it doesn't exist for current resolution
WALL="$CACHE_PATH/$(basename "$IMG").png"
if [ ! -f "$WALL" ]; then
    echo -e "  Resizing..."
    SIZE=($(/usr/bin/identify -format "%w %h" "$IMG"))
    X=$((SIZE[0]*RES[1]))
    Y=$((SIZE[1]*RES[0]))

    # calc wallpaper size and area to cut
    if [[ $X > $Y ]]; then
        W=$((X/SIZE[1]))
        H=${RES[1]}
        WCUT=$(((W-RES[0])/2))
        HCUT=0
    else
        W=${RES[0]}
        H=$((Y/SIZE[0]))
        WCUT=0
        HCUT=$(((H-RES[1])/2))
    fi

    # create wallpaper
    mkdir -p "$CACHE_PATH"
    MAGICK_OCL_DEVICE=OFF convert "$IMG" -resize "${W}x${H}" -shave "${WCUT}x${HCUT}" "$WALL"
fi

# set wallpaper
if pgrep xfdesktop >/dev/null; then
    PROPERTY="/backdrop/screen0/monitor0/image-path"
    xfconf-query -c xfce4-desktop -p $PROPERTY -s "$WALL"
    # for terminal fake transparency
    /usr/bin/feh --bg-fill "$WALL" ||
        /usr/bin/xv -root -quit "$WALL"
else
    /usr/bin/feh --bg-fill "$WALL" ||
        /usr/bin/xv -root -quit "$WALL"
fi

ln -sf "$WALL" ~/wallpaper.png

