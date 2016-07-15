#! /bin/bash

## Start variables
NAME='unzip'
EXTENSION='.tar.gz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Configure the source
./configure
# Build using the configured sources
make -j "$CORES" -f unix/Makefile generic
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make prefix=/usr MANDIR=/usr/share/man/man1 -f unix/Makefile install
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
