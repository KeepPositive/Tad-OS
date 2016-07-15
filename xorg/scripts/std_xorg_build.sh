#! /bin/bash

PACKAGE=$1
VERSION=$2
FOLD_NAME=$PACKAGE-$VERSION


tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"
pushd "$FOLD_NAME"

# Configure the source
./configure $XORG_CONFIG
# Build using the configured sources
make -j "$CORES"
# Install the built package

popd
rm -rf $FOLD_NAME
