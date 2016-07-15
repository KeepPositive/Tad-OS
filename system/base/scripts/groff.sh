#! /bin/bash

PACKAGE="groff"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"


tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Configure the source (and paper size?)
PAGE=letter ./configure --prefix=/usr
# Build using the configured sources
make -j1
# Install the built package

popd

rm -rf "$FOLD_NAME"
