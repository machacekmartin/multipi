# !/bin/bash

DISK="/dev/disk4"

diskutil unmountDisk $DISK

################ PURGE AND CREATE PARTITIONS ################
sudo diskutil partitionDisk $DISK GPT \
    "MS-DOS FAT32" BATOCERA_B 4GB \
    "ExFAT" BATOCERA_R 32GB \
    "MS-DOS FAT32" LIBREELEC_B 4GB \
    "ExFAT" LIBREELEC_R 32GB \
    "Free Space" Free R

diskutil unmountDisk $DISK


################ FORMAT EXT4 PARTITIONS ################
sudo $(brew --prefix e2fsprogs)/sbin/mkfs.ext4 -F ${DISK}s3
sudo $(brew --prefix e2fsprogs)/sbin/mkfs.ext4 -F ${DISK}s5


################ RETRIEVE UUID OF LIBREELEC PARTITIONS (batocera does not require this) ################
LIBREELEC_BOOT_PARTITION_IDENTIFIER=$(sudo dd if="$DISK"s4 bs=1m count=10 | file - | awk -F'serial number 0x' '{split($2,a,","); print a[1]}')
LIBREELEC_BOOT_PARTITION_UUID="${LIBREELEC_BOOT_PARTITION_IDENTIFIER:0:4}-${LIBREELEC_BOOT_PARTITION_IDENTIFIER:4:4}"
LIBREELEC_ROOT_PARTITION_UUID=$(sudo dd if="$DISK"s5 bs=1m count=10 | file - | grep -Eo 'UUID=[0-9a-fA-F-]+' | cut -d= -f2)

diskutil mountDisk $DISK

################ RETRIEVE IMAGES ################
if [ -f ./images/downloaded/batocera.img ]; then
    echo "Batocera image already exists"
else
    curl -L -o ./images/downloaded/batocera.img.gz https://updates.batocera.org/bcm2712/stable/last/batocera-bcm2712-41-20241217.img.gz
    gunzip ./images/downloaded/batocera.img.gz
fi

if [ -f ./images/downloaded/libreelec.img ]; then
    echo "LibreELEC image already exists"
else
    curl -L -o ./images/downloaded/libreelec.img.gz https://releases.libreelec.tv/LibreELEC-RPi5.aarch64-12.2.0.img.gz
    gunzip ./images/downloaded/libreelec.img.gz
fi


################ ATTACH IMAGES FOR COPYING ################
hdiutil attach ./images/downloaded/batocera.img -mountpoint ./images/mounted/batocera
hdiutil attach ./images/downloaded/libreelec.img -mountpoint ./images/mounted/libreelec


################ COPY CONTENTS OF IMAGES AND AUTOBOOT CONFIG ################
cp -r ./images/mounted/batocera/* /Volumes/BATOCERA_B
cp -r ./images/mounted/libreelec/* /Volumes/LIBREELEC_B
cp -r ./efi/* /Volumes/EFI


################ APPLY CUSTOM PARTITIONS INTO CMDLINE configuration ################
cat <<EOF > /Volumes/BATOCERA_B/cmdline.txt
console=tty3 loglevel=3 elevator=deadline vt.global_cursor_default=0 logo.nologo dev=LABEL=BATOCERA_B rootwait fastboot noswap
EOF
cat <<EOF > /Volumes/LIBREELEC_B/cmdline.txt
boot=UUID=$LIBREELEC_BOOT_PARTITION_UUID disk=UUID=$LIBREELEC_ROOT_PARTITION_UUID quiet console=ttyAMA10,115200 console=tty0
EOF

################ COPY REBOOT SCRIPTS ################
mkdir -p /Volumes/BATOCERA_B/reboot
mkdir -p /Volumes/LIBREELEC_B/reboot
cp -r ./reboot/* /Volumes/BATOCERA_B/reboot
cp -r ./reboot/* /Volumes/LIBREELEC_B/reboot

################ DETACH AND UNMOUNT ################
hdiutil detach ./images/mounted/batocera
hdiutil detach ./images/mounted/libreelec
diskutil unmountDisk $DISK

echo "================================== YOUR PI IS READY =================================="

