#! /bin/bash

## Start variables
NAME='xz'
EXTENSION='.tar.xz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Prevent an error
sed -e '/mf\.buffer = NULL/a next->coder->mf.size = 0;' \
    -i src/liblzma/lz/lz_encoder.c
# Configure the source
./configure --prefix=/usr    \
            --disable-static \
            --docdir="/usr/share/doc/$FOLDER_NAME"
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
  mv -v /usr/lib/liblzma.so.* /lib
  ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
