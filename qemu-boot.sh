#!/bin/bash

# Check for elevated privileges.
if [ $EUID -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

# Using tinycore kernel extracted bzimage from latest ISO (17.x) and updated initrmfs.
# Found this by booting tinycore kernel in QEMU and noticed MOTD posted on successful startup
# grep'd through initramfs for any startup/MOTD files and appended to it.
KERNEL_URL="https://github.com/ULopez54/qemu-boot/raw/refs/heads/main/bzImage-tinycore"
INITRAMFS_URL="https://github.com/ULopez54/qemu-boot/raw/refs/heads/main/initramfs-custom.gz"
KERNEL=$(basename $KERNEL_URL)
INITRAMFS=$(basename $INITRAMFS_URL)

# Missing dependencies (QEMU and must be 64 bit compatible).
# Used to use ! which but didn't seem as portable.
if ! command -v qemu-system-x86_64 &> /dev/null; then
    echo "Please install qemu-system."
fi

# Download kernel image/iniramfs, -L for github redirection, -O for same name as remote.
curl -L -O $KERNEL_URL
curl -L -O $INITRAMFS_URL

# Super simple call.
qemu-system-x86_64 -kernel $KERNEL -initrd $INITRAMFS
