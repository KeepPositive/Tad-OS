#! /bin/bash

## Start variables
PACKAGE="alsa-plugins"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

pushd "$FOLD_NAME"

# Configure the source
./configure
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL" -eq 1 ]
then
    make install
fi

popd

rm -rf "$FOLD_NAME"
## End script
