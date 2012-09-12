#!/bin/bash
#bin=qtcreator
bin=~/apps/qtcreator-build-release/bin/qtcreator

PATH=/usr/lib/ccache/bin:$PATH
ccache --max-size=8G

exec $bin -lastsession

