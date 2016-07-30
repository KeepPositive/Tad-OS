#! /bin/bash

## Start variables
NAME='pulseaudio'
EXTENSION='.tar.xz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Hide a bunch of error messages
sed -i "/seems to be moved/s/^/#/" build-aux/ltmain.sh
# Configure the source
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-bluez4     \
            --disable-rpath
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  rm /etc/dbus-1/system.d/pulseaudio-system.conf
  sed -i '/load-module module-console-kit/s/^/#/' /etc/pulse/default.pa
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
