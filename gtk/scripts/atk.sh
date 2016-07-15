#! /bin/bash

## Start variables
PACKAGE="atk"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr
# Build using the configured sources
make -j "$CORES"
# Install the built package

popd

rm -rf "$FOLD_NAME"
## End script
