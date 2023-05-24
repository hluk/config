#!/bin/bash
set -e
cd ~/dev/lastfm_wallpaper/
exec poetry run lastfm_wallpaper --days=30 --count=12 --space=24 "$@"
