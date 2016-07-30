#! /bin/bash

## Start variables
NAME='json-c'

## End variables

## Start script
# Enter the source directory
pushd "$SOURCE_DIR/$NAME"
# Configure the source
sed -i s/-Werror// Makefile.in
./configure --prefix=/usr --disable-static
# Build using the configured sources
# Note: this package must be built using one core
make -j 1
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  make clean
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
