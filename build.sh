#!/bin/bash

set -e 
set -o pipefail

set -x

#rm NOOBS_latest

#wget https://downloads.raspberrypi.org/NOOBS_latest.torrent
#wget https://downloads.raspberrypi.org/NOOBS_latest
#wget https://downloads.raspberrypi.org/raspbian_lite/root.tar.xz


rm -rf unpack 2> /dev/null
mkdir unpack
unzip NOOBS_latest -d unpack

echo "runinstaller quiet ramdisk_size=32768 root=/dev/ram0 init=/init vt.cur_default=1 elevator=deadline silentinstall" > unpack/recovery.cmdline

rm -rf unpack/os/Libr*
cp root.tar.xz unpack/os/Raspbian/root.tar.xz

cd unpack/os/Raspbian

mkdir root

tar -xJf root.tar.xz -C root
cd root

cp /usr/bin/qemu-arm-static usr/bin/

# ansible
ansible-playbook playbook.yaml -i hosts

exit 0

cd ..

tar -cJf root.tar.xz -C root .
rm -rf root

mkdir boot
tar -xJf boot.tar.xz -C boot

cd boot

sed -i s/audio=on// config.txt
echo "dtoverlay=hifiberry-dacplus" >> config.txt

cd ..

tar -cJf boot.tar.xz -C boot .
rm -rf boot




