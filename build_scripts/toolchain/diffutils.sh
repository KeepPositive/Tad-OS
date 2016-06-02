#! /bin/bash

PACKAGE=""
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"
pushd "$FOLD_NAME"

# Configure the source


# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]; then
    make install
fi

popd
rm -rf "$FOLD_NAME"
