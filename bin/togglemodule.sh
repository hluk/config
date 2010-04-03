#!/bin/sh
# load/unload specified modules

# sudoers should contain line:
# %users  myhost = NOPASSWD: modprobe <module-name>, modprobe -r <module-name>

for module in $@
do
    lsmod|grep -q $module &&
        sudo modprobe -r $module ||
        sudo modprobe $module
done

