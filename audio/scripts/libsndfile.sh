#! /bin/bash

## Start variables
PACKAGE="libsndfile"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr    \
            --disable-static \
            --docdir="/usr/share/doc/libsndfile-$VERSION"
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
