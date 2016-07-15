#! /bin/bash

## Start variables
PACKAGE="x264"
VERSION=$1
FOLD_NAME="$PACKAGE-snapshot-$VERSION-stable"

## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr    \
            --enable-shared  \
            --disable-cli
# Build using the configured sources
make -j "$CORES"
# Install the built package

popd

rm -rf "$FOLD_NAME"
## End script
