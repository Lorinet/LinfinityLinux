#!/bin/bash
cd /setup
apt -y install --no-install-recommends sudo nano task-gnome-desktop network-manager-gnome gnome-shell-extensions appmenu-gtk-module-common
apt install linux-image-amd64
bootctl install
kernvers=$(ls /boot/vml* | cut -c 15-)
mkdir /boot/efi/linfinity
cp /boot/vmlinuz-${kernvers} /boot/efi/linfinity/vmlinuz
cp /boot/initrd.img-${kernvers} /boot/efi/linfinity/initrd.img
cat > /boot/efi/loader/entries/linfinity.conf << EOF
title Linfinity Linux
linux /linfinity/vmlinuz
initrd /linfinity/initrd.img
options root=/dev/sda2 rw
EOF

usermod -aG sudo linfinity
apt-add-repository contrib
apt-add-repository non-free
apt -y update
apt -y install wget fonts-inter fonts-hack xzip xz-utils gzip zip unzip zstd python3-pip
mkdir -pv /usr/share/gnome-shell/extensions
for ext in extensions/*
do
    xdr=/usr/share/gnome-shell/$(echo ${ext} | rev | cut -c 21- | rev)
    mkdir -pv $xdr
    unzip $ext -d $xdr
done
for pkg in packages/*
do
    apt install ./$pkg
done
pip install future
wget https://github.com/lassekongo83/adw-gtk3/releases/download/v3.1/adw-gtk3v3-1.tar.xz
sudo mkdir -pv /usr/share/themes
sudo tar -xJf adw-gtk3v3-1.tar.xz -C /usr/share/themes
sudo mkdir -pv /etc/dconf/profile
sudo cat > /etc/dconf/profile/user << EOF
user-db:user
system-db:local
EOF
sudo mkdir -pv /etc/dconf/db/local.d
sudo cat > /etc/dconf/db/local.d/01-theme << EOF
[org/gnome/desktop/interface]
gtk-theme="adw-gtk3"
font-name="Inter 11"
monospace-font-name="Hack 10"

[org/gnome/shell]
enabled-extensions=['blur-my-shell@aunetx', 'fildemGMenu@gonza.com', 'ubuntu-dock@ubuntu.com', 'Hide_Activities@zeten30.gmail.com']

[org/gnome/desktop/wm/preferences]
button-layout="close:minimize,maximize"
EOF
sudo cat > /etc/skel/.gtkrc-2.0 << EOF
gtk-modules="appmenu-gtk-module"
EOF
sudo mkdir -pv /etc/skel/.config/gtk-3.0
sudo cat > /etc/skel/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-modules="appmenu-gtk-module"
EOF
dconf update
mkdir -pv /etc/xdg/autostart
cat > /etc/xdg/autostart/fildem.desktop << EOF
[Desktop Entry]
Type=Application
Name=Global Menu
Exec=fildem
Terminal=false
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF
chmod +x /etc/xdg/autostart/fildem.desktop
sudo cat > /etc/skel/.nanorc << EOF
set tabstospaces
set tabsize 4
set autoindent
set linenumbers
EOF


echo "test
test
Linfinity Linux





" | adduser linfinity
usermod -aG sudo linfinity
