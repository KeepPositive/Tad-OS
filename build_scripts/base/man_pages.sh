#! /bin/bash

PACKAGE="man-pages"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]
then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Install the package
if [ "$INSTALL_SOURCES" -eq 1 ]; then
    make install
fi

popd

rm -rf "$FOLD_NAME"
