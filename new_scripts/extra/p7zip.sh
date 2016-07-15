#! /bin/bash

## Start variables
NAME='p7zip'
EXTENSION='.tar.'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/_src_all$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/${PACKAGE_FILE}"
# Enter the source directory
pushd "$FOLDER_NAME"
# Configure the source
./configure
# Build using the configured sources
make -j "$CORES" all
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  DEST_HOME=/usr \
  DEST_MAN=/usr/share/man \
  DEST_SHARE_DOC="/usr/share/doc/$FOLDER_NAME" install
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
