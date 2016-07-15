#! /bin/bash

PACKAGE="dejagnu"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/tools

# Install the built package
popd

rm -rf "$FOLD_NAME"
