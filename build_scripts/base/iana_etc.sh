#! /bin/bash

PACKAGE="iana-etc"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

pushd "$FOLD_NAME"

# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]; then
    make install
fi

popd

rm -rf "$FOLD_NAME"
