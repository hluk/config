#!/bin/bash
set -e

cd ~/dev/xitomatl
exec poetry run xitomatl 2> .xitomatl.log
