#!/bin/bash
N=0x`sudo setpci -s 00:02.0 F4.B`
if [ -n "$1" ]
then
    N=$((N+$1))
    if [ $N -gt 255 ]
    then
        N=255
    elif [ $N -lt 0 ]
    then
        N=0
    fi
    sudo setpci -s 00:02.0 F4.B=`printf '%x' $N`
fi
echo $N

