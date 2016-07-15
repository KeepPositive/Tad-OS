#! /bin/bash

PACKAGE="gettext"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-$VERSION
# Build using the configured sources
make -j "$CORES"
# Install the built package

popd

rm -rf "$FOLD_NAME"
