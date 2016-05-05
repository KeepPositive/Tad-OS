#! /bin/bash

# Initial directories
LFS=/mnt/lfs
LFS_TGT=$(uname -m)-lfs-linux-gnu
LFS_TOOL="$LFS/tools"
LFS_SRC="$LFS/source"
# Toolchain related variables
LC_ALL=POSIX
DEFAULT_GROUP=lfs
DEFAULT_USER=lfs
DEFAULT_PASS="tados"
SRC_DIR=/source
TOOL_DIR=/tools
PATH="$TOOL_DIR/bin":/bin:/usr/bin


## Start script
for directory in "$LFS" "$LFS_TOOL" "$LFS_SRC"
if [ -d "$LFS" ]
then
    mkdir -v $directory
if

ln -sv $LFS_TOOL
# Create a user and a group which are named lfs
groupadd "$DEFAULT_GROUP"
useradd -s /bin/bash -g "$DEFAULT_GROUP" -m -k /dev/null "$DEFAULT_USER"
# Set a password for the lfs user
echo "$DEFAULT_PASS" > passwd "$DEFAULT_USER"
# Change ownership
chown -v "$DEFAULT_USER" "$LFS_TOOL"
chown -v "$DEFAULT_USER" "$LFS_SRC"

sudo -u "$DEFAULT_USER" "printf"
