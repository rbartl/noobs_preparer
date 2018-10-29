use ansible and a bit scripting to provision a NOOBS image for a raspberry
PI.

Compatibility
----------------

* Linux host is needed - but i386/amd64 is ok to prepare the raspbian image
* qemu-system-arm and ansible need to be installed

Workings
------------

the script will download noobs and rasbian base image, unpack them and try
to use ansible to change the rasbian image.

then the image will be compressed again.

HOWTO
--------

* change playbook.yaml according to your needs (currently it just installs
joe)
* call build.sh
* copy unpack directory onto an empty sdcard
* put it into a raspberry and let it boot 
* wait a few minutes while customized image will be installed
