#! /bin/bash

## Start variables
PACKAGE="openbox"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --docdir="/usr/share/doc/openbox-$VERSION"
# Build using the configured sources
make -j "$CORES"
# Install the built package

popd

rm -rf "$FOLD_NAME"
## End script
