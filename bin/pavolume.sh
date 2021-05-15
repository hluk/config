#!/bin/bash
exec pactl set-sink-volume @DEFAULT_SINK@ "$1"
