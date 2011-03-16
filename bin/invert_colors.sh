#!/bin/sh
# switch between redshift and invert
DIR=`dirname "$0"`
killall redshift && sleep 0.5 && ~/dev/colors/invert || "$DIR/redshift.sh"

