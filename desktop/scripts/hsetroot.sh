#! /bin/bash

## Start variables
PACKAGE="hsetroot"
VERSION="master"
FOLD_NAME="$PACKAGE-$VERSION"

## End variables

## Start script
tar xf "$PACKAGE_DIR/$VERSION.tar.gz"

pushd "$FOLD_NAME"

# Configure the source
#./configure --prefix=/usr
# Build using the configured sources
make -j "$CORES"
# Install the built package

popd

rm -rf "$FOLD_NAME"
## End script
