#!/bin/bash

echo "Linfinity Linux"
echo "<=============>"

function installToolkit {
    echo "Installing build tools..."
    sudo apt -y update
    sudo apt -y install debootstrap build-essential
}

function createLoopback {
    echo "Creating disk image..."
    dd if=/dev/zero of=linfinity.linux.img bs=1M count=5000 > /dev/null
    echo "Setting up loopback device..."
    lodev=$(sudo losetup -f)
    sudo losetup $lodev linfinity.linux.img
    echo "Loopback device: "
    echo $lodev
    cat << EOF | sudo gdisk $lodev
o
y
n


+512M
ef00
n




w
y
EOF
    echo "Partprobe..."
    sudo partprobe $lodev
    echo "Formatting EFI partition..."
    sudo mkfs.fat -F 32 ${lodev}p1
    echo "Formatting Linux partition..."
    sudo mkfs -t ext4 ${lodev}p2
    sudo mkdir rootfs
    sudo mkdir -p rootfs/dev/pts
    sudo mkdir -p rootfs/sys
    sudo mkdir -p rootfs/proc
    echo "Mounting image..."
    sudo mount ${lodev}p2 rootfs
    sudo mkdir -p rootfs/boot/efi
    sudo mkdir -p rootfs/proc
    sudo mkdir -p rootfs/sys
    sudo mkdir -p rootfs/dev
    sudo mount ${lodev}p1 rootfs/boot/efi
}

function unmount {
    sudo umount rootfs/boot/efi
    sudo umount rootfs
}

function chroot {
    sudo mount --rbind /proc rootfs/proc
    sudo mount --rbind /sys rootfs/sys
    sudo mount --rbind /dev rootfs/dev
    sudo chroot rootfs
    sudo mount --make-rslave rootfs/dev/
    sudo umount -R -l rootfs/dev/
    sudo mount --make-rslave rootfs/sys/
    sudo umount -R -l rootfs/sys
    sudo mount --make-rslave rootfs/proc/
    sudo umount -R -l rootfs/proc
}

function buildBase {
    echo "Building base system..."
    sudo mkdir linfinity
    sudo debootstrap --arch amd64 --variant=minbase --include=systemd,systemd-sysv,systemd-boot,gdm3,gnome-core --exclude=sysvinit-core,sysvinit-utils bookworm rootfs http://deb.debian.org/debian
}

function cleanup {
    echo "Cleaning up"
    sudo rm -rf linfinity
}

$1 $2
