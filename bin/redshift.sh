#!/bin/bash
killall -q redshift
#exec redshift -l 49.0:16.7 -t 6500:3200 -r
exec redshift -l 52:22 -t 6200:3200 -r

