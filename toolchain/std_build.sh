#! /bin/bash

#  For building toolchain related tools which have very simple install
# instructions

PACKAGE=$1
VERSION=$2
FOLD_NAME="$PACKAGE-$VERSION"
FILE_TYPE=$3

if [ -z "$CORES" ]
then
	CORES='4'
fi

tar xvf "$PACKAGE_DIR/$FOLD_NAME$FILE_TYPE"
pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/tools

# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL" -eq 1 ]; then
    make install
fi

popd
rm -rf "$FOLD_NAME"
