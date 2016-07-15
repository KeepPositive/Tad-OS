#! /bin/bash

PACKAGE="sed"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr --bindir=/bin --htmldir=/usr/share/doc/sed-$VERSION
# Build using the configured sources
make -j "$CORES"
#make -j "$CORES" html
# Install the built package

popd

rm -rf "$FOLD_NAME"
