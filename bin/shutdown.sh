#!/bin/sh
# file: shudown.sh
urxvt -name rxvtpopup -geometry 20x2+520+500 -e /bin/sh -c '
	echo -e "\033[0;31mSHUTDOWN\033[0m"
	su -c "shutdown -hP now" || (echo "Bad password!"; read)'

