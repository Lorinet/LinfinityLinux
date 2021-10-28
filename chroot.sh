#!/bin/bash
echo "Linfinity Linux Setup"
echo "Setting up users..."
echo -e "linfinity\nlinfinity" | passwd
apt -y update
apt -y upgrade
echo "Installing Linux image..."
apt -y install linux-image-generic
echo "Installing Nano..."
apt -y install nano
echo "Installing GNOME desktop..."
apt -y install python3 python3-pip xorg gnome-session gnome-shell-common gdm3 gnome-terminal human-theme intel-microcode sudo dhcpcd5 gnome-software gnome-software-plugin-flatpak
echo "Installing apps..."
apt -y install firefox gnome-calculator nautilus gedit geary libreoffice gnome-system-monitor gnome-disk-utility gnome-clocks gnome-calendar gnome-music totem gnome-photos gnome-weather eog evince gnome-screenshot gnome-sound-recorder fonts-hack-ttf fonts-noto-core fonts-inter ttf-mscorefonts-installer
cd /setup
apt -y install desktop-file-utils git valac libgranite-dev libpackagekit-glib2-dev libunity-dev meson ninja-build libzeitgeist-2.0-dev gettext
git clone https://github.com/donadigo/eddy.git
cd eddy
meson build && cd build
meson configure -Dprefix=/usr
ninja
ninja install
ln -svf $(which com.github.donadigo.eddy) /bin/eddy
apt-get autoclean
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
dpkg-reconfigure tzdata
systemctl enable dhcpcd
apt -y remove gdm3
apt -y remove gnome-software-plugin-snap
apt -y remove snapd
echo "NAutoVTs=1" >> /etc/systemd/logind.conf
mkdir -pv /etc/systemd/system/getty@tty1.service.d
cat << EOF > /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin root --noclear %I 38400 linux
EOF
echo "[ `tty` == /dev/tty1 ] && startx" > /root/.bashrc
systemctl enable getty@tty1
echo "startx" > /root/.bashrc
echo "Installing Shell Extensions..."
mkdir -pv /etc/dconf/db/local.d
cat << EOF > /etc/dconf/db/local.d/00-extensions
[org/gnome/shell]
enabled-extensions=['blur-me@nunchucks', 'caffeine@patapon.info', 'drive-menu@gnome-shell-extensions.gcampax.github.com', 'gsconnect@andyholmes.github.io']
EOF
dconf update
fc-cache -f -v
