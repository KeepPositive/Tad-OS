#! /bin/bash

## Start variables
PACKAGE="unzip"
VERSION=$1
FOLD_NAME="$PACKAGE$VERSION"

## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Build using the configured sources
make -j "$CORES" -f unix/Makefile generic
# Install the built package

popd

rm -rf "$FOLD_NAME"
## End script
