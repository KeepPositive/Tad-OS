#! /bin/bash

## Start variables
NAME='linux'
EXTENSION='.tar.xz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Clean the sources
make mrproper
# Install the tidy sources
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make INSTALL_HDR_PATH=dest headers_install
  cp -rv dest/include/* /tools/include
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
