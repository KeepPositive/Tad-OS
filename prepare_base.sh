#! /bin/bash

## Start variables
START_DIR=$(pwd)
CONFIGURE_FILE="$START_DIR/build.cfg"
for name in "LFS"
do
    # The 'eval' command evaluates a string into runable bash
    eval "export $name=$(grep $name "$CONFIGURE_FILE" | awk '{print $2}')"

    if [ "$?" -ne 0 ]
    then
        echo "$name could not be created! Error!"
        exit 1
    fi
done
## End variables

## Start script

# Exit on errors
set -o errexit

# Make some directories so the toolchain can run
mkdir -pv $LFS/{dev,proc,sys,run}

# Populate the console and null files
mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3

# mount the directories created earlier
mount -v --bind /dev $LFS/dev
mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

# Create some symlink to prevent errors later on.
if [ -h $LFS/dev/shm ]
then
    mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

# Change to the toolchain system
chroot "$LFS" /tools/bin/env -i                   \
    HOME=/root                                    \
    TERM="linux"                                  \
    PS1='\u:\w\$ '                                \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h
