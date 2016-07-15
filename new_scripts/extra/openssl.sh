#! /bin/bash

## Start variables
NAME='openssl'
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
./configure --prefix=/usr         \
            --openssldir=/etc/ssl \
            --libdir=lib          \
            shared                \
            zlib-dynamic          \
            no-rc5 no-idea
# Build using the configured sources
make -j $CORES depend
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  # Disable static libraries
  sed -i 's# libcrypto.a##;s# libssl.a##' Makefile
  make MANDIR=/usr/share/man MANSUFFIX=ssl install
  # Install the documentation properly
  install -dv -m755 "/usr/share/doc/$FOLDER_NAME"
  cp -vfr doc/* "/usr/share/doc/$FOLDER_NAME"
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
