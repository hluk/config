#!/bin/bash
HELP="Download flash videos from specified URLs or from URLs in clipboard.\n"
CMD=~/apps/get-flash-videos/get_flash_videos
CMD2=~/apps/get-flash-videos/list_flash_videos
DIR=~/down/_flash

# default {VARIABLE} [value]
# set default value of variable (do not override if exists)
default () {
    eval "$1=\${$1:-'$2'}"
    HELP="$HELP  $1 = $2\n$(cat)\n"
}

default PLAY 1 <<.
    play video
.
default PLAYER mplayer <<.
    video player command
.
default PLAYLIST 0 <<.
    download all items in youtube playlist
    if ends with .m3u then items are saved to m3u file
.
default SKIP 0 <<.
    number of items to skip in playlist
.
default M3U "" <<.
    M3U playlist filename
.

if [[ "$1" =~ ^(|-|--)(h|help|\?)$ ]]
then
    exec printf "$HELP"
fi

# URLS (or search terms) from arguments or X11 clipboard
if [ -n "$1" ]
then
    URLS=$@
else
    #URLS=`xclip -o`
    URLS=`~/dev/copyq-build/release/copyq read`
fi

if [[ "$PLAYLIST" = "1" || -n "$M3U" ]]
then
    URLS=`curl --silent $URLS | sed -rn '/data-video-ids=/{s/.*data-video-ids="/,/;s/".*//;s_,([^,]*)_http://www.youtube.com/watch?v=\1 _g;p}' | tail -1 | tr ' ' \\\\n | tail -n +$((SKIP+1))`
fi

if [ -n "$M3U" ]
then
    #"$CMD2" $URLS
    #mv playlist.m3u "$M3U"
    echo "$URLS" > "$M3U"
    exit
fi

if [ "$PLAY" = "1" ]
then
    ARGS="$ARGS --player '$PLAYER' --subtitles --play"
fi

mkdir -p "$DIR" || exit 1
(
cd "$DIR" &&
"$CMD" $ARGS $URLS
)

