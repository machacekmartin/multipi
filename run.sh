# !/bin/bash

DISK="/dev/disk4"

diskutil unmountDisk $DISK
echo "--- Unmounted disk ---"

sudo diskutil partitionDisk $DISK 1 GPT "Free Space" Free R
echo "--- Partitioned disk ---"

diskutil addPartition $DISK "MS-DOS FAT32" BATOCERA_B 4GB
echo "--- Added BATOCERA_B partition ---"

diskutil addPartition $DISK ExFAT BATOCERA_R 32GB
echo "--- Added BATOCERA_R partition ---"

diskutil addPartition $DISK "MS-DOS FAT32" LIBREELEC_B 4GB
echo "--- Added LIBREELEC_B partition ---"

diskutil addPartition $DISK ExFAT LIBREELEC_R 32GB
echo "--- Added LIBREELEC_R partition ---"

diskutil unmountDisk $DISK

sudo $(brew --prefix e2fsprogs)/sbin/mkfs.ext4 -F ${DISK}s3
sudo $(brew --prefix e2fsprogs)/sbin/mkfs.ext4 -F ${DISK}s5
echo "--- Formatted ext4 partitions ---"

LIBREELEC_BOOT_PARTITION_IDENTIFIER=$(sudo dd if="$DISK"s4 bs=1m count=10 | file - | awk -F'serial number 0x' '{split($2,a,","); print a[1]}')
LIBREELEC_BOOT_PARTITION_UUID="${LIBREELEC_BOOT_PARTITION_IDENTIFIER:0:4}-${LIBREELEC_BOOT_PARTITION_IDENTIFIER:4:4}"
LIBREELEC_ROOT_PARTITION_UUID=$(sudo dd if="$DISK"s5 bs=1m count=10 | file - | grep -Eo 'UUID=[0-9a-fA-F-]+' | cut -d= -f2)
echo "--- Retrieved UUIDs of partitions ---"

curl -L -o ./images/libreelec_12.2.0.img.gz https://releases.libreelec.tv/LibreELEC-RPi5.aarch64-12.2.0.img.gz

gzip -dc ./images/libreelec_12.2.0.img.gz | sudo dd of="$DISK"s4 bs=4m status=progress


# cp -r ./batocera/* /Volumes/BATOCERA_B
# echo "--- Copied data into BATOCERA_B partition ---"

# cp -r ./libreelec/* /Volumes/LIBREELEC_B
# echo "--- Copied data into LIBREELEC_B partition ---"

# diskutil mountDisk $DISK

# cp -r ./efi/* /Volumes/EFI
# echo "--- Copied data into EFI partition ---"

# mkdir -p /Volumes/BATOCERA_B/reboot
# mkdir -p /Volumes/LIBREELEC_B/reboot

# cp -r ./reboot/* /Volumes/BATOCERA_B/reboot
# echo "--- Copied custom reboot scripts into BATOCERA_B partition ---"

# cp -r ./reboot/* /Volumes/LIBREELEC_B/reboot
# echo "--- Copied custom reboot scripts into LIBREELEC_B partition ---"

# cat <<EOF > /Volumes/LIBREELEC_B/cmdline.txt
# boot=UUID=$LIBREELEC_BOOT_PARTITION_UUID disk=UUID=$LIBREELEC_ROOT_PARTITION_UUID quiet console=ttyAMA10,115200 console=tty0
# EOF

# diskutil unmountDisk $DISK

# echo "--- DONE ---"

