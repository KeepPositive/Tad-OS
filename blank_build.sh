#! /bin/bash

PACKAGE=
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

if [ -z "$CORES"]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"
pushd "$FOLD_NAME"

# Configure the source

# Build using the configured sources
make -j "$CORES"
# Install the built package
# make install
if [ $INSTALL -eq 1 ]; then
    
fi

popd
rm -rf $FOLD_NAME
