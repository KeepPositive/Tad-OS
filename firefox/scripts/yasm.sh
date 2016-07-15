#! /bin/bash

## Start variables
PACKAGE="yasm"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

#Stop compilation of useless programs 
sed -i 's#) ytasm.*#)#' Makefile.in &&
# Configure the source
./configure --prefix=/usr
# Build using the configured sources
make -j "$CORES"
# Install the built package

popd

rm -rf "$FOLD_NAME"
## End script
