umount -l imgroot
umount -l efi
losetup -d $1
rm -rf imgroot
rm -rf efi
rm -rf rootfs
rm linfinity.linux.img
