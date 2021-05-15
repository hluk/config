#!/bin/bash
script_root="$(dirname "$(readlink -f "$0")")"
exec "$script_root/pavolume.sh" -1000
#exec "$script_root/volume.sh" 1%-
