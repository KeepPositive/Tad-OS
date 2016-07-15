#! /bin/bash

PACKAGE="rpi"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "linux-$FOLD_NAME"

# Clean the sources
make mrproper

# Install the built package

popd

rm -rf "linux-$FOLD_NAME"
