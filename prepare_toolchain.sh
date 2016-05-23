#! /bin/bash

## Start variables
# Some of these variables are editable in the toolchain.cfg file, so check it out
START_DIR=$(pwd)
SCRIPT_DIR="$START_DIR/build_scripts/toolchain"
PACKAGE_DIR="$START_DIR/packs/base"
CONFIGURE_FILE="$START_DIR/build_scripts/build.cfg"
LFS=$(grep "LFS" "$CONFIGURE_FILE" | awk '{print $2}')
LFS_TOOL="$LFS/tools"
LFS_SRC="$LFS/source"

#  This script takes values from the configuration file, and turns them into 
# usable variables within the script. The names in the beginning of the for
# loop are all editable values within the toolchain.cfg file.

set -o errexit

for name in "SYSTEM" "MOUNT_DEVICE" "DEFAULT_NAME"
do
    # The 'eval' command evaluates a string into runable bash
    eval "export $name=$(grep $name "$CONFIGURE_FILE" | awk '{print $2}')"

    if [ "$?" -ne 0 ]
    then
        echo "$name could not be created! Error!"
        exit 1
    fi
done

case "$SYSTEM" in

    "rpi")
        # Specifically for the Raspberry Pi 3
        LFS_TGT=$(uname -m)-lfs-linux-gnueabihf
    ;;

    *)
        # For a standard 32 bit or 64 bit computer
        LFS_TGT=$(uname -m)-lfs-linux-gnu
    ;;

esac

## End variables

## Start script

set -o errexit

#  Most things run inside the script need root access, so check if run by root
# using the id command
if [ "$(id -u)" -ne 0 ]
then
    echo "You need to be root to run this script!"
    exit 1
fi

# Create the mount directory
if [ ! -d "$LFS" ]
then
    mkdir -v "$LFS"
fi

# Mount the partition where Tad OS will be built, if it isn't already mounted
if ! grep -qs "$LFS" /proc/mounts
then
    echo "Mounting $MOUNT_DEVICE at $LFS"
    mount "$MOUNT_DEVICE" "$LFS"
else
    echo "$MOUNT_DEVICE is already mounted on $LFS!"
fi

# Make the tools and source directories in LFS
for directory in "$LFS_TOOL" "$LFS_SRC" 
do
    if [ ! -d "$directory" ]
    then
        mkdir -v "$directory"
    fi
done

# force a symbolic link to /tools on your system to the $LFS/tools directory
printf "Linking " #For style purposes only
ln -sfv "$LFS_TOOL" /

# Check if the default user exists
if ! id -u "$DEFAULT_NAME" #&> /dev/null
then
    echo "Creating user $DEFAULT_NAME in group $DEFAULT_NAME"
    # Create a user and a group which are named lfs
    groupadd "$DEFAULT_NAME"
    useradd -s /bin/bash -g "$DEFAULT_NAME" -m -k /dev/null "$DEFAULT_NAME"
    # Set a password for the lfs user
    echo "Please set a password for the $DEFAULT_NAME user:"
    passwd "$DEFAULT_NAME"
    mkdir -pv "/home/$DEFAULT_NAME"
else
    echo "Seems the user $DEFAULT_NAME already exists. Continuing."
fi

# Copy build scripts into LFS for the DEFAULT_USER to access
cp -r "$SCRIPT_DIR" "$LFS"
cp -r "$START_DIR/build_scripts/base" "$LFS"

# If source file does not exists in LFS_SRC, copy the package there
for package in $(find "$PACKAGE_DIR" -type f -printf "%f\n")
do
    if [ ! -f "$LFS_SRC/$package" ] 
    then
        echo "Copying $package to $LFS_SRC"
        cp "$PACKAGE_DIR/$package" "$LFS_SRC"
    fi
done

# Copy over the configuration file
cp "$START_DIR/build_scripts/build.cfg" "$LFS"

# Copy over the base build script to LFS
cp "$START_DIR/build_toolchain.sh" "$LFS"
cp "$START_DIR/prepare_base.sh" "$LFS"
cp "$START_DIR/build_base"* "$LFS"

# Make bash_profile which sets the default terminal values
cat > "/home/$DEFAULT_USER/.bash_profile" << 'EOF'
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

# Make bashrc which defines environment variables for programs to use.
cat > "/home/$DEFAULT_USER/.bashrc" << EOF
set +h
umask 022
LFS=$LFS
LC_ALL=POSIX
LFS_TGT=$LFS_TGT
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
EOF

# Change ownership of LFS_TOOL and LFS_SRC
for directory in "$LFS_SRC" "$LFS_TOOL" "/home/$DEFAULT_NAME"
do
    chown -Rhv "$DEFAULT_NAME" "$directory"
done

chown -v "$DEFAULT_NAME" "$LFS"

echo "Done. Now run build_toolchain.sh as the $DEFAULT_NAME user in the $LFS directory."

## End script

