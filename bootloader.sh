#!/bin/bash
echo "Linfinity Linux Setup"
echo "Installing bootloader..."
mkdir -pv /boot/efi
mount $1"p1" /boot/efi
bootctl --esp-path=/boot/efi install
rootpart=$1"p2"
blkidcmd="blkid -o value -s UUID $rootpart"
UUID=$($blkidcmd)
echo "UUID: "$UUID
KERNELS=()
FIND="find /boot -maxdepth 1 -name 'vmlinuz-*' -type f -print0 | sort -rz"
while IFS= read -r -u3 -d $'\0' LINE; do
    KERNEL=$(basename "${LINE}")
    KERNELS+=("${KERNEL:8}")
done 3< <(eval "${FIND}")

if [ ${#KERNELS[@]} -lt 1 ]; then
    echo -e "\e[2msystemd-boot\e[0m \e[1;31mNo kernels found.\e[0m"
    exit 1
fi

rm /boot/efi/loader/entries/*.conf
rm -rf /boot/efi/linfinity
mkdir /boot/efi/linfinity

LATEST="${KERNELS[@]:0:1}"
echo -e "\e[2msystemd-boot\e[0m \e[1;32m${LATEST}\e[0m"
for FILE in config initrd.img System.map vmlinuz; do
    cp "/boot/${FILE}-${LATEST}" "/boot/efi/linfinity/${FILE}"
    cat << EOF > /boot/efi/loader/entries/linfinity.conf
title   Linfinity Linux
linux   /linfinity/vmlinuz
initrd  /linfinity/initrd.img
options root=UUID=${UUID} rw
EOF
done
umount -l /boot/efi
echo "Done"
