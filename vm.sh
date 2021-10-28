#!/bin/bash
qemu-system-x86_64 -enable-kvm -m 4096 -bios /usr/share/ovmf/OVMF.fd -hda linfinity.linux.img
