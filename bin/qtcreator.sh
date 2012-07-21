#!/bin/bash
PATH=/usr/lib/ccache/bin:$PATH
ccache --max-size=4G
exec qtcreator -lastsession

