#! /bin/bash

## Start variables
PACKAGE="unzip"
VERSION=$1
FOLD_NAME="$PACKAGE$VERSION"

if [ -z "$CORES" ]
then
	CORES=4
fi
## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Build using the configured sources
make -j "$CORES" -f unix/Makefile generic
# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]
then
    make prefix=/usr MANDIR=/usr/share/man/man1 -f unix/Makefile install
fi

popd

rm -rf "$FOLD_NAME"
## End script
