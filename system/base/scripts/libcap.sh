#! /bin/bash

## Start variables
NAME='libcap'
EXTENSION='.tar.xz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Disable static libraries
sed -i '/install.*STALIBNAME/d' libcap/Makefile
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make RAISE_SETFCAP=no prefix=/usr install
  chmod -v 755 /usr/lib/libcap.so
  mv -v /usr/lib/libcap.so.* /lib
  ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
