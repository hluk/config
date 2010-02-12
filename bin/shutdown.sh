#!/bin/sh
# file: shudown.sh
echo -e "\033[0;31mSHUTDOWN\033[0m"
su -c "/sbin/shutdown -hP now" || (echo "Bad password!"; read)

