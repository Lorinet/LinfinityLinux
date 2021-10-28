#!/bin/bash
apt -y install gdm3
systemctl disable getty@tty1
rm /root/.bashrc
reboot
