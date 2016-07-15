#! /bin/bash

## Start variables
PACKAGE="xinit"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

pushd "$FOLD_NAME"

# Configure the source
./configure $XORG_CONFIG --with-xinitdir=/etc/X11/xinit
# Build using the configured sources
make -j "$CORES"
# Install the built package

popd

rm -rf "$FOLD_NAME"
## End script
