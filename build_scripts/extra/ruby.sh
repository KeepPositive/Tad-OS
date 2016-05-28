#! /bin/bash

## Start variables
PACKAGE="ruby"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]
then
	CORES=4
fi
## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr       \
            --enable-shared     \
            --docdir=/usr/share/doc/ruby-$VERSION
# Build using the configured sources
make -j "$CORES"
make -j "$CORES" capi
# Install the built package
if [ "$INSTALL" -eq 1 ]
then
    make install
fi

popd

rm -rf "$FOLD_NAME"
## End script
