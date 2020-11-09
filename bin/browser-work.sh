#!/bin/bash
exec "$(dirname "$0")/browser.sh" -P work "$@" &>/dev/null
