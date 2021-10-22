#!/bin/bash
# Enables emulating Ctrl with Space key if pressed with other key.
set -exuo pipefail

dir=$(dirname "$0")
patch=$dir/install_space2ctrl.diff
config=$dir/install_space2ctrl.yaml

sudo dnf -y copr enable fszymanski/interception-tools
sudo dnf -y install interception-tools
sudo cp "$config" /etc/interception/udevmon.d/space2ctrl.yml

cd ~/dev/
test -d space2meta ||
    git clone git@gitlab.com:interception/linux/plugins/space2meta.git
cd space2meta
if ! patch -R -p1 -s -f --dry-run < "$patch"; then
  patch -p1 < "$patch"
fi

cmake -Bbuild
cmake --build build
sudo cmake --build build --target install
sudo systemctl enable --now udevmon
