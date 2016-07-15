#! /bin/bash

PACKAGE="check"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"
pushd "$FOLD_NAME"

# Configure the source
PKG_CONFIG= ./configure --prefix=/tools

# Build using the configured sources
make -j "$CORES"

# Install the built package
popd
rm -rf "$FOLD_NAME"
