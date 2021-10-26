#!/bin/bash
echo "Linfinity Linux Setup"
apt -y update
apt -y upgrade
echo "Installing Linux image..."
apt -y install linux-image-generic
echo "Installing Nano..."
apt -y install nano
echo "Installing GNOME desktop..."
apt -y install gnome-session gdm3
echo "Installing Eddy..."
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
