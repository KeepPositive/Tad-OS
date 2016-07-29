#! /bin/bash

## Start variables
NAME='dbus'
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
./configure --prefix=/usr                          \
            --sysconfdir=/etc                      \
            --localstatedir=/var                   \
            --disable-static                       \
            --disable-doxygen-docs                 \
            --disable-xml-docs                     \
            --docdir="/usr/share/doc/$FOLDER_NAME" \
            --with-console-auth-dir=/run/console
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  mv -v /usr/lib/libdbus-1.so.* /lib
  ln -sfv ../../lib/$(readlink /usr/lib/libdbus-1.so) /usr/lib/libdbus-1.so
  ln -sfv /etc/machine-id /var/lib/dbus
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
