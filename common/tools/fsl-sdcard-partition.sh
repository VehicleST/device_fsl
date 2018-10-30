#!/bin/bash

# android-tools-fsutils should be installed as
# "sudo apt-get install android-tools-fsutils"

# partition size in MB
BOOTLOAD_RESERVE=1
BOOT_ROM_SIZE=32
SYSTEM_ROM_SIZE=1536
CACHE_SIZE=512
RECOVERY_ROM_SIZE=32
DEVICE_SIZE=16
MISC_SIZE=4
DATAFOOTER_SIZE=2
METADATA_SIZE=2
FBMISC_SIZE=1
PRESISTDATA_SIZE=1
DATA_SIZE=5530

help() {

bn=`basename $0`
cat << EOF
usage $bn <option> device_node

options:
  -h				displays this help message
  -s				only get partition size
  -np 				not partition.
  -f soc_name			flash android image.
EOF

}

# parse command line
moreoptions=1
node="na"
soc_name=""
cal_only=0
bootloader_offset=1
flash_images=0
not_partition=0
not_format_fs=0
bootloader_file="u-boot.imx"
bootimage_file="boot.img"
systemimage_file="system.img"
systemimage_raw_file="system_raw.img"
recoveryimage_file="recovery.img"
partition_file="partition-table.img"
while [ "$moreoptions" = 1 -a $# -gt 0 ]; do
	case $1 in
	    -h) help; exit ;;
	    -s) cal_only=1 ;;
	    -f) flash_images=1 ; soc_name=$2; shift;;
	    -np) not_partition=1 ;;
	    -nf) not_format_fs=1 ;;
	    *)  moreoptions=0; node=$1 ;;
	esac
	[ "$moreoptions" = 0 ] && [ $# -gt 1 ] && help && exit
	[ "$moreoptions" = 1 ] && shift
done

if [ "${soc_name}" = "imx8dv" ]; then
    bootloader_offset=16
fi

if [ "${soc_name}" = "imx8qm" -o "${soc_name}" = "imx8qxp" ]; then
    bootloader_offset=33
fi

if [ ! -e ${node} ]; then
	help
	exit
fi


# create partitions
if [ "${cal_only}" -eq "1" ]; then
cat << EOF
BOOT   : ${BOOT_ROM_SIZE}MB
RECOVERY: ${RECOVERY_ROM_SIZE}MB
SYSTEM : ${SYSTEM_ROM_SIZE}MB
CACHE  : ${CACHE_SIZE}MB
MISC   : ${MISC_SIZE}MB
DEVICE : ${DEVICE_SIZE}MB
DATAFOOTER : ${DATAFOOTER_SIZE}MB
METADATA : ${METADATA_SIZE}MB
FBMISC   : ${FBMISC_SIZE}MB
PRESISTDATA : ${PRESISTDATA_SIZE}MB
DATA : ${DATA_SIZE}MB
EOF
exit
fi

function format_android
{
    echo "formating android images"
    mkfs.ext4 -F ${node}10 -L data
    mkfs.ext4 -F ${node}3 -Lsystem
    mkfs.ext4 -F ${node}4 -Lcache
    mkfs.ext4 -F ${node}5 -Ldevice
}
function make_partition
{
    echo "make gpt partition for android"
    dd if=${partition_file} of=${node} conv=fsync
}

function flash_android
{
    bootloader_file="u-boot-${soc_name}.imx"
    bootimage_file="boot-${soc_name}.img"
    recoveryimage_file="recovery-${soc_name}.img"
if [ "${flash_images}" -eq "1" ]; then
    echo "flashing android images..."    
    echo "bootloader: ${bootloader_file} offset: ${bootloader_offset}"
    echo "boot image: ${bootimage_file}"
    echo "recovery image: ${recoveryimage_file}"
    echo "system image: ${systemimage_file}"
    dd if=${bootimage_file} of=${node}1 conv=fsync
    dd if=${recoveryimage_file} of=${node}2 conv=fsync
    simg2img ${systemimage_file} ${systemimage_raw_file}
    dd if=${systemimage_raw_file} of=${node}3 conv=fsync
    rm ${systemimage_raw_file}
    dd if=/dev/zero of=${node} bs=1k seek=${bootloader_offset} conv=fsync count=800
    dd if=${bootloader_file} of=${node} bs=1k seek=${bootloader_offset} conv=fsync
fi
}

if [[ "${not_partition}" -eq "1" && "${flash_images}" -eq "1" ]] ; then
    flash_android
    exit
fi

make_partition
sleep 3
for i in `cat /proc/mounts | grep "${node}" | awk '{print $2}'`; do umount $i; done
hdparm -z ${node}

# backup the GPT table to last LBA for sd card.
echo -e 'r\ne\nY\nw\nY\nY' |  gdisk ${node}

format_android
flash_android


# For MFGTool Notes:
# MFGTool use mksdcard-android.tar store this script
# if you want change it.
# do following:
#   tar xf mksdcard-android.sh.tar
#   vi mksdcard-android.sh 
#   [ edit want you want to change ]
#   rm mksdcard-android.sh.tar; tar cf mksdcard-android.sh.tar mksdcard-android.sh
