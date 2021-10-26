#!/bin/bash
echo " Linfinity Linux Build Tool "
echo "<==========================>"

ARCH=amd64

function installBuildDeps {
    apt install debootstrap
}

function downloadUbuntu {
    debootstrap impish rootfs http://archive.ubuntu.com/ubuntu/
    cat << EOF > rootfs/etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu/ impish main restricted
deb http://archive.ubuntu.com/ubuntu/ impish-updates main restricted
deb http://archive.ubuntu.com/ubuntu/ impish universe
deb http://archive.ubuntu.com/ubuntu/ impish-updates universe
deb http://archive.ubuntu.com/ubuntu/ impish multiverse
deb http://archive.ubuntu.com/ubuntu/ impish-updates multiverse
deb http://archive.ubuntu.com/ubuntu/ impish-security main restricted
deb http://archive.ubuntu.com/ubuntu/ impish-security universe
deb http://archive.ubuntu.com/ubuntu/ impish-security multiverse
EOF
    echo "/dev/sda1 / ext4 defaults,errors=remount-ro 0 1" > rootfs/etc/fstab
}

function enterChroot {
    mount --bind /sys rootfs/sys
    mount -t proc /proc rootfs/proc
    mount --bind /dev rootfs/dev
    mount --bind /dev/pts rootfs/dev/pts
    chroot rootfs /bin/bash $1
    umount -l rootfs/dev/pts
    umount -l rootfs/dev
    umount -l rootfs/proc
    umount -l rootfs/sys
}

function configureRootfs {
    mkdir rootfs/setup
    cp chroot.sh rootfs/setup
    enterChroot /setup/chroot.sh
}

function createImage {
    dd if=/dev/zero of=linfinity.linux.img bs=1024M count=8
}

function partitionImage {
    device=$(losetup -f)
    losetup $device linfinity.linux.img
    echo $device
    gdisk $device << EOF
o
y
n
1

+512M
ef00
n
2



w
y
EOF
    partprobe /dev/loop0
    mkdir efi
    mkdir imgroot
    mount "$device"p1 efi
    mkfs.ext4 "$device"p2
    mount "$device"p2 imgroot
}

$1
