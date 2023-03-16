#!/bin/bash
bin=qtcreator
#bin=~/apps/qtcreator-test/bin/qtcreator.sh

PATH=/usr/lib/ccache/bin:$PATH
ccache --max-size=8G

ulimit -c unlimited
[ "`ulimit -c`" = "unlimited" ] || { echo "Core files cannot be generated!"; exit 1; }

export LLVM_INSTALL_DIR="/usr"

source /etc/profile
exec "$bin" -theme dark -lastsession
