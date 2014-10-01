#!/bin/bash
distro=${1:-"ubuntu:14.04"}
shift

sudo docker run -t -i "$distro" "$@"
