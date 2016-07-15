#! /bin/bash

PACKAGE="man-pages"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"


tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Install the package
popd

rm -rf "$FOLD_NAME"
