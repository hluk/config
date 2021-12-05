#!/bin/bash
# Enables emulating key modifiers with other keys.
set -exuo pipefail

if [[ ! -f /usr/bin/udevmon ]]; then
    sudo dnf -y copr enable fszymanski/interception-tools
    sudo dnf -y install interception-tools
fi

cd ~/dev/
test -d space2meta ||
    git clone git@gitlab.com:lholecek/space2meta.git
cd space2meta
git checkout custom-keys

build() {
    set -ex

    exe_name=$1
    key_src=$2
    key_tgt=$3

    dir=build-$exe_name

    cmake -B"$dir" \
        -DEXE_NAME="$exe_name" \
        -DKEY_SRC="$key_src" \
        -DKEY_TGT="$key_tgt"
    cmake --build "$dir"
    sudo cmake --build build --target install
}

build space2ctrl KEY_SPACE KEY_LEFTCTRL

sudo systemctl enable --now udevmon
sudo tee /etc/interception/udevmon.d/modifiers.yaml <<EOF
---
- JOB: intercept -g \$DEVNODE | space2ctrl | uinput -d \$DEVNODE
  DEVICE:
    EVENTS:
      EV_KEY:
        - KEY_F
        - KEY_SPACE
EOF
