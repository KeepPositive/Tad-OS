#! /bin/bash

## Start variables

PACKAGE="bc"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

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
if [ "$INSTALL_SOURCES" -eq 1 ]; then
    make install
fi

popd

rm -rf "$FOLD_NAME"
