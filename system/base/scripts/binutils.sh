#! /bin/bash

## Start variables
NAME='binutils'
EXTENSION='.tar.bz2'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Verify some things using expect
expect -c "spawn ls"
# Leave the source directory
popd
# Make a build directory
mkdir "$FOLDER_NAME/build"
#Enter the build directory
pushd "$FOLDER_NAME/build"
# Configure the source
./configure --prefix=/usr    \
            --enable-shared  \
            --disable-werror
# Build using the configured sources
make tooldir=/usr -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make tooldir=/usr install
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
