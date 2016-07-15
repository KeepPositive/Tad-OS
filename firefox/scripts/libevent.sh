#! /bin/bash

## Start variables
PACKAGE="libevent"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION-stable"

## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr --disable-static
# Build using the configured sources
make -j "$CORES"
# Install the built package

popd

rm -rf "$FOLD_NAME"
## End script
