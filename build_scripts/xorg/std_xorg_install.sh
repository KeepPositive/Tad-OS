#! /bin/bash

PACKAGE=$1
VERSION=$2
FOLD_NAME=$PACKAGE-$VERSION

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"
pushd "$FOLD_NAME"

# Configure the source
./configure "$XORG_CONFIG"
# Install the package
if [ $INSTALL -eq 1 ]; then
    make install
fi

popd
rm -rf $FOLD_NAME
