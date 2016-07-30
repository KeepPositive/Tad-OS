#! /bin/bash

## Start variables
NAME='intltool'
EXTENSION='.tar.gz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Prevent a warning later on
sed -i 's:\\\${:\\\$\\{:' intltool-update.in
# Configure the source
./configure --prefix=/usr
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  install -v -Dm644 doc/I18N-HOWTO "/usr/share/doc/$FOLDER_NAME/I18N-HOWTO"
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
