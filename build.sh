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

function mount {
    lodev=$(sudo losetup -f)
    sudo losetup $lodev linfinity.linux.img
    sudo partprobe $lodev
    sudo mkdir rootfs
    sudo mount ${lodev}p2 rootfs
    sudo mount ${lodev}p1 rootfs/boot/efi
}

function unmount {
    dv=$(grep -w rootfs /proc/mounts | cut -d " " -f)
    sudo umount rootfs/boot/efi
    sudo umount rootfs
    sudo losetup -d $dv
    sudo losetup -d ${dv}p1
    sudo losetup -d ${dv}p2
    sudo partprobe
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
    sudo debootstrap --arch amd64 --variant=minbase --include=systemd,systemd-sysv,systemd-boot,wget --exclude=sysvinit-core,sysvinit-utils bookworm rootfs http://deb.debian.org/debian
}

function setup {
    sudo mkdir rootfs/setup
    sudo cp setup.sh rootfs/setup
    sudo cp -r extensions rootfs/setup
    sudo cp -r packages rootfs/setup
    sudo mount --rbind /proc rootfs/proc
    sudo mount --rbind /sys rootfs/sys
    sudo mount --rbind /dev rootfs/dev
    sudo chroot rootfs /bin/bash /setup/setup.sh
    sudo mount --make-rslave rootfs/dev/
    sudo umount -R -l rootfs/dev/
    sudo mount --make-rslave rootfs/sys/
    sudo umount -R -l rootfs/sys
    sudo mount --make-rslave rootfs/proc/
    sudo umount -R -l rootfs/proc
}

function cleanup {
    echo "Cleaning up"
    sudo rm -rf linfinity
}

function run {
    qemu-system-x86_64 -accel kvm -vga qxl -bios /usr/share/ovmf/OVMF.fd -m 4096 -hda linfinity.linux.img
}

$1 $2
