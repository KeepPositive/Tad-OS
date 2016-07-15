#! /bin/bash

## Start variables
#  Note: This package is downloaded straight from GitHub, so the build
# is a little simpler
NAME='libepoxy'
FOLDER_NAME=$NAME
## End variables

## Start script
# Enter the source directory
pushd "$SOURCE_DIR/$PACKAGE_FILE"
# Configure the source
./autogen.sh
./configure --prefix=/usr
# Build the sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
