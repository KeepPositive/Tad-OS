#! /bin/bash

## Start variables
NAME='tcl'
EXTENSION='.tar.gz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/-src$EXTENSION//" -e "s/-core//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME/unix"
# Configure the source
./configure --prefix=/tools
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  chmod -v u+w /tools/lib/libtcl8.6.so
  make install-private-headers
  ln -sfv tclsh8.6 /tools/bin/tclsh
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
