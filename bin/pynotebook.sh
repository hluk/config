#!/bin/sh
export PYTHONPATH=$HOME/apps/fakevim/build:$PYTHONPATH

set -e
cd ~/dev
exec ipython notebook
