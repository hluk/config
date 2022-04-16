#!/bin/bash

echo -e "\e[1mbold\e[0m"
echo -e "\e[3mitalic\e[0m"
echo -e "\e[3m\e[1mbold italic\e[0m"
echo -e "\e[4munderline\e[0m"
echo -e "\e[9mstrikethrough\e[0m"
echo -e '\e[4:3m\e[58:2::240:143:104mundercurl\e[59m\e[4:0m'

# Tests support for truecolor on terminal.
# https://gist.github.com/XVilka/8346728
exec awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum+1,1);
    }
    printf "\n";
}'
