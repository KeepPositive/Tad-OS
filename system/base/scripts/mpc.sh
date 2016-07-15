#! /bin/bash

PACKAGE="mpc"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"
# Configure the source
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.0.3
# Build using the configured sources
make -j "$CORES"
#make -j "$CORES" html
# Install the built package

popd

rm -rf "$FOLD_NAME"
