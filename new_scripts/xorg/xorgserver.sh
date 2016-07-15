#! /bin/bash

## Start variables
NAME='xorg-server'
EXTENSION='.tar.bz2'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Configure the source
if [ "$FOLDER_NAME" -eq "xorg-server-1.18.3" ]
then
  patch -Np1 -i "$SOURCE_DIR/xorg-server-1.18.3-add_prime_support-1.patch"
fi
./configure $XORG_CONFIG            \
           --enable-glamor          \
           --enable-install-setuid  \
           --enable-suid-wrapper    \
           --enable-kdrive          \
           --with-xkb-output=/var/lib/xkb
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  mkdir -pv /etc/X11/xorg.conf.d
  for line in "/tmp/.ICE-unix dir 1777 root root" \
              "/tmp/.X11-unix dir 1777 root root"
  do
    printf '%s\n', "$line" > /etc/sysconfig/createfiles
  done
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
