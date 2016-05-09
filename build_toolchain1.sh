#! /bin/bash

RUN_USER=$(id -u)
## Global script variables
START_DIR=$(pwd)
SCRIPT_DIR="$START_DIR/toolchain"
PACKAGE_DIR="$START_DIR/packs/base"
## Initial directories for LFS. Edit these, except for the TGT one.
MOUNT_DIR=/dev/sda7
LFS=/mnt/lfs
LFS_TOOL="$LFS/tools"
LFS_SRC="$LFS/source"
# For a 64 bit computer
LFS_TGT=$(uname -m)-lfs-linux-gnu
# For the Raspberry Pi
#LFS_TGT=$(uname -m)-lfs-linux-gnueabihf
# The name of the group the default user will be added to
DEFAULT_GROUP=lfs
# The name of the default user
DEFAULT_USER=lfs
USER_EXIST=""
# The default password for the user
DEFAULT_PASS="tados"

## Start script
# Most things run inside the script need root access, so check if run by root
if [ "$RUN_USER" -ne 0 ]
then
    echo "You need to be root to run this script!"
    exit 1
fi
# Create some directories
if [ ! -d "$LFS" ]
then
    mkdir -v $LFS
fi
# Mount the partition where Tad OS will be built, if it isn't already mounted
mount | grep "$MOUNT_DIR on $LFS" > /dev/null
if [ ! $? -eq 0 ]
then
    mount "$MOUNT_DIR" "$LFS"
fi
# Make the tools and source directories in LFS
for directory in "$LFS_TOOL" "$LFS_SRC" "/home/$DEFAULT_USER"
do
    if [ ! -d "$directory" ]
    then
        mkdir -v $directory
    fi
done
# force a symbolic link to /tools of your system, do so
ln -sfv "$LFS_TOOL" /
# Check if the default user exists
id -u "$DEFAULT_USER" &> /dev/null
if [ $? -eq 1 ]
then
    # Create a user and a group which are named lfs
    groupadd "$DEFAULT_GROUP"
    useradd -s /bin/bash -g "$DEFAULT_GROUP" -m -k /dev/null "$DEFAULT_USER"
    # Set a password for the lfs user
    passwd "$DEFAULT_USER" --stdin
else
    echo "Seems the $DEFAULT_USER already exists. Continuing."
fi
# Copy build scripts into LFS for the DEFAULT_USER to access
cp -r "$SCRIPT_DIR" "$LFS"
# Copy all of the packages too
cp "$PACKAGE_DIR"/* "$LFS_SRC"
# Copy over the second part of the build script to LFS
cp "$START_DIR/build_toolchain2.sh" "$LFS"
# Make bash_profile which sets the default terminal values
cat > /home/$DEFAULT_USER/.bash_profile << 'EOF'
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF
# Make bashrc which defines environment variables for programs to use.
cat > /home/$DEFAULT_USER/.bashrc << EOF
set +h
umask 022
LFS=$LFS
LC_ALL=POSIX
LFS_TGT=$LFS_TGT
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
EOF

# Change ownership of LFS_TOOL and LFS_SRC
chown -v "$DEFAULT_USER" "$LFS"
