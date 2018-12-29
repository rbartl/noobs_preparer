#!/bin/bash

set -e 
set -o pipefail

set -x

if [ ! -f NOOBS_latest ] ; then 
 wget https://downloads.raspberrypi.org/NOOBS_latest
fi
if [ ! -f root.tar.xz ] ; then
 wget https://downloads.raspberrypi.org/raspbian_lite/root.tar.xz
fi


rm -rf unpack 2> /dev/null
mkdir unpack
unzip NOOBS_latest -d unpack

echo "runinstaller quiet ramdisk_size=32768 root=/dev/ram0 init=/init vt.cur_default=1 elevator=deadline silentinstall" > unpack/recovery.cmdline
OSDIR=Raspbian_Full

rm -rf unpack/os/Libr*
cp root.tar.xz unpack/os/${OSDIR}/root.tar.xz

cd unpack/os/${OSDIR}

mkdir root

tar -xJf root.tar.xz -C root
mkdir root/boot
tar -xJf ../boot.tar.xz -C root/boot

cd root

cp /usr/bin/qemu-arm-static usr/bin/


# ansible
cd ../../../..
ansible-playbook playbook.yaml -i hosts


cd unpack/os/${OSDIR}

tar -cJf boot.tar.xz -C root/boot .
rm -rf root/boot

tar -cJf root.tar.xz -C root .
rm -rf root






