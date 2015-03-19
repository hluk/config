#!/bin/bash
set -e

build_dir=${1:-"$HOME/apps/build/qtcreator-Qt_5-Debug"}
dst=${2:-"$HOME/apps/qtcreator-test"}

#rm -rf -- "$dst"
#mkdir -p "$dst"
#cp -r -- "$build_dir"/{bin,lib,share} "$dst"
rsync --recursive --links --delete -- "$build_dir"/{bin,lib,share} "$dst"/

