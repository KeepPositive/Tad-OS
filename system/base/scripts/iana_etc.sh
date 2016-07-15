#! /bin/bash

PACKAGE="iana-etc"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

pushd "$FOLD_NAME"

# Build using the configured sources
make -j "$CORES"
# Install the built package
popd

rm -rf "$FOLD_NAME"
