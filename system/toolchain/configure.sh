#! /bin/bash

## Start variables
# Some of these variables are editable in the build.cfg file, so check it out

CONFIGURE_FILE="../build.conf"
LFS=$(grep "LFS" "$CONFIGURE_FILE" | awk '{print $2}')
LFS_TOOL="$LFS/tools"
LFS_SRC="$LFS/sources"

#  This script takes values from the configuration file, and turns them into
# usable variables within the script. The names in the beginning of the for
# loop are all editable values within the build.cfg file.
for name in 'SYSTEM' 'MOUNT_DEVICE' 'DEFAULT_NAME'
do
  # The 'eval' command evaluates a string into runable bash
  eval "export $name=$(grep $name $CONFIGURE_FILE | awk '{print $2}')"
  # If eval fails, end the script
  if [ "$?" -ne 0 ]
  then
    echo "$name could not be created! Error!"
    exit 1
  fi
done

case "$SYSTEM" in
  "rpi")
    # Specifically for the Raspberry Pi
    LFS_TGT=$(uname -m)-lfs-linux-gnueabihf
  ;;
  *)
    # For a standard 32 bit or 64 bit computer
    LFS_TGT=$(uname -m)-lfs-linux-gnu
  ;;
esac
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

# Check if the default user exists
if ! id -u "$DEFAULT_NAME" &> /dev/null
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

# Make bash_profile which sets the default terminal values
if [ ! -f "/home/$DEFAULT_NAME/.bash_profile" ]
then
  printf "exec env -i HOME=/home/$DEFAULT_NAME TERM=linux PS1='\u:\w\$ ' /bin/bash\n\n" \
         >> "/home/$DEFAULT_NAME/.bash_profile"

  echo "Created bash_profile for $DEFAULT_NAME"
fi

# Make bashrc which defines environment variables for programs to use.
if [ ! -f "/home/$DEFAULT_NAME/.bashrc" ]
then
  for line in 'set +h' 'umask 022' "LFS=$LFS" 'LC_ALL=POSIX'      \
              "LFS_TGT=$LFS_TGT" 'PATH=/tools/bin:/bin:/usr/bin'  \
              'export LFS LC_ALL LFS_TGT PATH'
  do
    echo "$line" >> "/home/$DEFAULT_NAME/.bashrc"
  done
  echo "Created bashrc for $DEFAULT_NAME"
fi

# Change ownership of the LFS directory itself
chown -Rc "$DEFAULT_NAME:$DEFAULT_NAME" "$LFS"

# Change ownership of directories recursively
for directory in "$LFS_SRC" "$LFS_TOOL" "/home/$DEFAULT_NAME" "$LFS/toolchain"
do
  chown -Rhc "$DEFAULT_NAME:$DEFAULT_NAME" "$directory"
done

# Change the ownership of the scripts
chown -c "$DEFAULT_NAME:$DEFAULT_NAME" "$LFS"/*.sh

# Ready to continue message
echo "Done, now run build.sh as the '$DEFAULT_NAME' user in the \
'$LFS/toolchain' directory"
## End script
