#! /bin/bash

PACKAGE=$1
VERSION=$2
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]
then
    CORES=4
fi

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

pushd "$FOLD_NAME"

# Configure the source
echo "XORG_CONFIG: $XORG_CONFIG" 
./configure $XORG_CONFIG
# Install the package
if [ "$INSTALL" -eq 1 ]
then
    make install
fi

popd
rm -rf "$FOLD_NAME"
