#!/bin/bash
coverity_path=$HOME/apps/cov-analysis-linux64-7.5.0/bin
export PATH=$coverity_path:$PATH

set -e
cov-build --dir cov-int "$@"
tar czvf myproject.tgz cov-int
