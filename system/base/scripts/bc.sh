#! /bin/bash

## Start variables

PACKAGE="bc"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

## End variables

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

pushd "$FOLD_NAME"

# Apply a patch here
patch -Np1 -i "$PACKAGE_DIR/bc-1.06.95-memory_leak-1.patch"
# Configure the source
./configure --prefix=/usr           \
            --with-readline         \
            --mandir=/usr/share/man \
            --infodir=/usr/share/info
# Build using the configured sources
make -j "$CORES"
# Install the built package
popd

rm -rf "$FOLD_NAME"
