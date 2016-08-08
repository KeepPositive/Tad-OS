#! /bin/bash

# This script generates a configuration file for some build groups
OUTPUT_FILE='./build.conf'

print_comment()
{
  echo "# $1" >> "$OUTPUT_FILE"
}

print_item()
{
  key=$1
  value=$2
  echo "$key: $value" >> "$OUTPUT_FILE"
  echo '' >> "$OUTPUT_FILE"
}

## Start script
if [ -f "$OUTPUT_FILE" ]
then
  rm "$OUTPUT_FILE"
fi

case $(uname -m) in
  'x86_64')
    SYSTEM_TYPE='x86_64'
  ;;
  'armv7l')
    case $(sed -n '/^Revision/s/^.*: \(.*\)/\1/p' < /proc/cpuinfo) in
      'a02082'|'a22082')
        SYSTEM_TYPE='rpi3'
      ;;
      *)
        SYSTEM_TYPE='rpi2'
      ;;
    esac
  ;;
esac

print_comment 'The system architecture being built for'
print_item 'SYSTEM_TYPE' "$SYSTEM_TYPE"

read -p 'Enter a partition: ' MOUNT_POINT
print_comment 'The virtual devices which should be mounted for the build'
print_item 'MOUNT_POINT' "$MOUNT_POINT"

print_comment 'The device to use for swap space, unless the value is 0'
print_item 'SWAP_DEVICE' '0'

print_comment 'Where the mount device should be mounted'
print_item 'LFS' '/mnt/lfs'

print_comment 'The name of the default build user'
print_item 'DEFAULT_NAME' 'lfs'

clear
print_comment 'The timezone for the OS to use'
print_item 'TIMEZONE' $(tzselect)
clear

print_comment 'The font locale to be used by the OS'
print_item 'LOCALE' 'en_US.UTF-8'

print_comment 'Whether to install the system (1) or just test it (0).'
print_item 'INSTALL_SOURCES' '0'
## End script
