#!/bin/bash
strace \
    --follow-forks \
    --string-limit=1024 \
    --trace=execve \
    "$@"
