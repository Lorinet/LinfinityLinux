#!/bin/bash
echo " Linfinity Linux Build Tool "
echo "<==========================>"

ARCH=amd64

function installBuildDeps {
    apt -y install debootstrap
}

function downloadFiles {
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
    echo -e "/dev/sda1 / ext4 defaults,errors=remount-ro 0 1\ntmpfs /tmpfs tmpfs rw,nosuid,nodev 0 0" > rootfs/etc/fstab
    echo "linfinity" > rootfs/etc/hostname
    echo "localhost     linfinity\n127.0.0.1    linfinity\n::1      linfinity ip6-localhost ip6-loopback\nff02::1       ip6-allnodes\nff02::2       ip6-allrouters" > /etc/hosts
    mkdir -pv rootfs/usr/share/sddm/themes
    cp -r linfinity-sddm rootfs/usr/share/sddm/themes/
}

function enterChroot {
    mount --bind /sys $1/sys
    mount -t proc /proc $1/proc
    mount --bind /dev $1/dev
    mount --bind /dev/pts $1/dev/pts
    chroot $1 /bin/bash $2
    umount -l $1/dev/pts
    umount -l $1/dev
    umount -l $1/proc
    umount -l $1/sys
}

function configureRootfs {
    mkdir rootfs/setup
    cp chroot.sh rootfs/setup
    cp bootloader.sh rootfs/setup
    cp firstboot.sh rootfs/setup
    mkdir -pv rootfs/etc/systemd/system
    cp firstboot.service rootfs/etc/systemd/system/
    cp -r extensions/* rootfs/usr/share/gnome-shell/extensions/
    cp lsb-release rootfs/etc/
    cp os-release rootfs/etc/
    enterChroot rootfs /setup/chroot.sh
}

lodev=

function createImage {
    echo "Creating linfinity.linux.img (8 GB)..."
    dd if=/dev/zero of=linfinity.linux.img bs=1024M count=8
    device=$(losetup -f)
    losetup $device linfinity.linux.img
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
    mkfs.vfat "$device"p1
    mkfs.ext4 "$device"p2
    lodev=$device
}

function mountImage {
    mkdir efi
    mkdir imgroot
    mount "$lodev"p1 efi
    mount "$lodev"p2 imgroot
}

function installImage {
    echo "Copying Linfinity Linux files..."
    cp -r rootfs/* imgroot/
    enterChroot imgroot "/setup/bootloader.sh $lodev"
}

function unmountImage {
    umount -l efi
    umount -l imgroot
    losetup -d $lodev
    echo "linfinity.linux.img built successfully!"
}

function buildImage {
    createImage
    mountImage
    installImage
    unmountImage
}

function buildAll {
    installBuildDeps
    downloadFiles
    configureRootfs
    buildImage
}

function mnt {
    lodev=$1
    mountImage
}

$@
