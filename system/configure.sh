#! /bin/sh

## Start variables
for name in 'LFS' 'MOUNT_POINT'
do
  # The 'eval' command evaluates a string into runable bash
  eval "export $name=$(grep $name './build.conf' | awk '{print $2}')"

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

# Check for root access
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
  echo "Mounting $MOUNT_POINT at $LFS"
  mount "$MOUNT_POINT" "$LFS"
else
  echo "$MOUNT_DEVICE is already mounted on $LFS!"
fi

# Copy all files in the 'system' group to new directory
for item in 'base' 'build.conf' 'configure.sh' 'sources' 'system_files' \
            'toolchain'
do
  cp -rv "./$item" "$LFS"
done

# Make the tools directory at $LFS/tools
mkdir -pv "$LFS/tools"

# Force a symbolic link to /tools on your system to the tools directory
printf "Linking " # For style purposes only

ln -sv "$LFS/tools" '/'
## End script
