#!/bin/bash
#screen -x default $@ || screen -R default $@
#exec screen -d -RR default $@

cd ~
export TERM="screen-256color"
export TMUX=""
tmux attach -d || tmux -2

