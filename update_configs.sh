#!/bin/bash
set -euo pipefail

shopt -s failglob

diff=${DIFF:-nvim -d}

home_configs=(
    .gitconfig
    .i3/*
    .tmux.conf
    .vimrc
    .Xresources
    .zshrc
)

configs=(
    openbox/*
)

# USAGE: create_or_diff <source> <destination>
# Creates config file in destination if it doesn't exist or shows diff.
create_or_diff() {
    src=$1
    dest=$2

    if [[ -f "$dest" ]]; then
        if ! diff --brief -- "$src" "$dest"; then
            $diff -- "$src" "$dest"
        else
            echo "Config '$src' ('$dest') is up to date."
        fi
    else
        dir=$(dirname -- "$dest")
        mkdir -vp -- "$dir"
        cp -v -- "$src" "$dest"
    fi
}

update_firefox() {
    for profile in ~/.mozilla/firefox/*.*/; do
        if [[ -d "$profile" ]]; then
            create_or_diff "firefox/userChrome.css" "$profile/chrome/userChrome.css"
        fi
    done
}

for config in "${home_configs[@]}"; do
    create_or_diff "$config" ~/"$config"
done

for config in "${configs[@]}"; do
    create_or_diff "$config" ~/.config/"$config"
done

update_firefox
