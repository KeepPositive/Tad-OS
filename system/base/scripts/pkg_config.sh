#! /bin/bash

PACKAGE="pkg-config"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr        \
            --with-internal-glib \
            --disable-compile-warnings \
            --disable-host-tool  \
            --docdir=/usr/share/doc/pkg-config-0.29.1
# Build using the configured sources
make -j "$CORES"
# Install the built package
popd

rm -rf "$FOLD_NAME"
