#!/bin/bash

mkdir mount > /dev/null 2> /dev/null

set -e
set -o pipefail

set -x

if [ "$1" == "" ] ; then 
  echo "supply the drive (e.g. sdb)"
  exit 2
fi
drive=$1


if ! lsblk /dev/${drive} --output MODEL,OWNER,TRAN | grep -i usb > /dev/null ; then 
  echo can only work on usb drives
  exit 1
fi



sfdisk /dev/${drive} <<EOF
label: dos
label-id: 0x00003481
device: /dev/sdc
unit: sectors

/dev/sdc1 : start=        2048, size=   124733440, type=b
EOF
sleep 2

mkfs.vfat /dev/${drive}1
mount /dev/${drive}1 mount

cp -a unpack/* mount/
umount mount
