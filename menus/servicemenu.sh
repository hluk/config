#!/bin/sh
SERVICESDIR=/home/lukas/dev/menus/services

SERVICECMD=`/bin/ls -1 $SERVICESDIR | /home/lukas/dev/menus/menu.sh "RUN:"`

if [ $? -eq 0 ]
then
	exec "$SERVICESDIR/$SERVICECMD"
fi

