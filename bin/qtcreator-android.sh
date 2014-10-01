#!/bin/bash
#bin=qtcreator
#bin=~/apps/qtcreator-build-release/bin/qtcreator.sh
bin=~/apps/Qt5.2.0/Tools/QtCreator/bin/qtcreator.sh

PATH=/usr/lib/ccache/bin:$PATH
ccache --max-size=8G

ulimit -c unlimited
[ "`ulimit -c`" = "unlimited" ] || { echo "Core files cannot be generated!"; exit 1; }

source /etc/profile
#export ANDROID_NDK_HOST=linux-x86_64
#export ANDROID_NDK_ROOT=$ANDROID_NDK
#export ANDROID_NDK_HOST=linux-x86
#export ANDROID_NDK_ROOT=/home/lukas/apps/necessitas/android-ndk
export ANDROID_NDK_HOST=linux-x86_64
export ANDROID_NDK_ROOT=/home/lukas/apps/android/android-ndk-r9b
"$bin" -lastsession

