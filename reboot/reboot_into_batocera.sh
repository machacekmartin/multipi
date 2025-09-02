#!/bin/bash

EFI_MOUNT=/tmp/boot
EFI_PARTITION=/dev/mmcblk0p1

mkdir -p $EFI_MOUNT
mount -t vfat $EFI_PARTITION $EFI_MOUNT

cat >> $EFI_MOUNT/autoboot.txt<< EOF
[all]
boot_partition=2
EOF

umount $EFI_MOUNT

reboot