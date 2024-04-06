#!/bin/bash
set -e
lock.sh
exec systemctl suspend
