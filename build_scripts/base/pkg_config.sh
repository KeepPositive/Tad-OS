#! /bin/bash

PACKAGE="pkg-config"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

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
if [ "$INSTALL" -eq 1 ]; then
    make install
fi

popd

rm -rf "$FOLD_NAME"
