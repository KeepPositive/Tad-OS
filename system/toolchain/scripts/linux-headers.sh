#! /bin/bash

PACKAGE="linux"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"
pushd "$FOLD_NAME"

# Clean the sources
make mrproper

# Install the built package

popd

rm -rf "$FOLD_NAME"
