#!/bin/bash

set -e 
set -o pipefail

set -x

if [ ! -f NOOBS_latest ] ; then 
 wget https://downloads.raspberrypi.org/NOOBS_latest
fi
if [ ! -f root.tar.xz ] ; then
 wget https://downloads.raspberrypi.org/raspios_lite_armhf/root.tar.xz
fi
if [ ! -f boot.tar.xz ] ; then
 wget https://downloads.raspberrypi.org/raspios_lite_armhf/boot.tar.xz
fi


rm -rf unpack 2> /dev/null
mkdir unpack
unzip NOOBS_latest -d unpack

echo "runinstaller quiet ramdisk_size=32768 root=/dev/ram0 init=/init vt.cur_default=1 elevator=deadline silentinstall" > unpack/recovery.cmdline
OSDIR=RaspiOS_Full_armhf

rm -rf unpack/os/Libr*
cp root.tar.xz unpack/os/${OSDIR}/root.tar.xz
cp boot.tar.xz unpack/os/${OSDIR}/boot.tar.xz

cd unpack/os/${OSDIR}

mkdir root

tar -xJf root.tar.xz -C root
tar -xJf boot.tar.xz -C root/boot


cd root

cp /usr/bin/qemu-arm-static usr/bin/


# ansible
cd ../../../..
ansible-playbook playbook.yaml -i hosts
for playbook in $USE_PLAYBOOKS ; do
  ansible-playbook $playbook -i hosts
done


cd unpack/os/${OSDIR}

tar -cJf boot.tar.xz -C root/boot .
rm -rf root/boot/

tar -cJf root.tar.xz -C root .
rm -rf root






