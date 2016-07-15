#! /bin/bash

## Start variables
PACKAGE="hicolor-icon-theme"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr
# Install the built package

popd

rm -rf "$FOLD_NAME"
## End script
