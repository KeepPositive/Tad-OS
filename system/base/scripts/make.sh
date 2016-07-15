#! /bin/bash

PACKAGE="make"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"
pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/tools --without-guile

# Build using the configured sources
make -j "$CORES"

# Install the built package
popd
rm -rf "$FOLD_NAME"
