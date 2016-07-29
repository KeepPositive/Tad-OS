#! /bin/bash

## Start variables
NAME='kbd'
EXTENSION='.tar.xz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Apply a patch
patch -Np1 -i "$PACKAGE_DIR/kbd-$VERSION-backspace-1.patch"
# Remove a useless program build
sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
# Configure the source
PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr \
                                                 --disable-vlock
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  mkdir -v "/usr/share/doc/$FOLDER_NAME"
  cp -R -v docs/doc/* "/usr/share/doc/$FOLDER_NAME"
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
