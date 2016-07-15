#! /bin/bash

## Start variables
NAME='xf86-video-ati'
EXTENSION='.tar.bz2'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
CONFIGURE_EXTRA_FIRMWARE=""
CONFIGURE_EXTRA_FIRMWARE_DIR="/lib/firmware"
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Configure the source
./configure $XORG_CONFIG
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  printf 'Section "Device"\nIdentifier "radeon"\nDriver "ati"\n \
         Option "AccelMethod" "glamor"\nEndSection' > \
         "$XORG_PREFIX/share/X11/xorg.conf.d/20-glamor.conf"
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
