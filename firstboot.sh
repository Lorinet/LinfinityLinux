#!/bin/bash
echo "Installing GDM3"
cd /setup
apt -y install ./gdm.deb
systemctl disable firstboot
echo "Installed GDM3"
