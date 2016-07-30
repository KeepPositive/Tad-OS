#! /bin/bash

## Start variables
NAME='Python'
EXTENSION='.tar.xz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-3*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Configure the source
CXX="/usr/bin/g++"              \
./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --without-ensurepip
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  chmod -v 755 /usr/lib/libpython3.5m.so
  chmod -v 755 /usr/lib/libpython3.so
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
