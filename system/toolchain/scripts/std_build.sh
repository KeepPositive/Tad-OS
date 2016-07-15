#! /bin/bash

#  For building toolchain related tools which have very simple install
# instructions

PACKAGE=$1
VERSION=$2
FOLD_NAME="$PACKAGE-$VERSION"
FILE_TYPE=$3


tar xvf "$PACKAGE_DIR/$FOLD_NAME$FILE_TYPE"
pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/tools

# Build using the configured sources
make -j "$CORES"

# Install the built package

popd
rm -rf "$FOLD_NAME"
