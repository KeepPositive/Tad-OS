#! /bin/bash

PACKAGE="xf86-video-intel"
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"
pushd "$FOLD_NAME"

# Configure the source
./configure $XORG_CONFIG --enable-uxa \
                         --enable-kms-only
                         
# Build using the configured sources
make -j "$CORES"

# Install the built package
# Make sure you have the kernel is configured correctly

popd
rm -rf "$FOLD_NAME"
