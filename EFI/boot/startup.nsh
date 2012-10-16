# arguments
# %1: use vmlinuz-linux%1 image
# %2...: kernel arguments
@echo -off

set fs fs0
set root UUID=7d9e23a7-593b-40d2-a628-8e9874c7a3b0
set args "usbcore.autosuspend=5 i915.modeset=1 quiet init=/usr/lib/systemd/systemd initrd=\initramfs-linux%1.img %2 %3 %4 %5 %6 %7 %8 %9"

%fs%:
cd %fs%:\

if exist vmlinuz-linux then
    echo "Updating Linux Kernel from %fs%:\vmlinuz-linux%1"
    rm vmlinuz-linux%1.efi
    mv vmlinuz-linux%1 vmlinuz-linux%1.efi
endif

echo "Launching Linux Kernel %fs%:\vmlinuz-linux%1.efi"
vmlinuz-linux%1.efi root=%root% ro %args%

