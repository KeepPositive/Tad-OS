#! /bin/bash

## Start variables
PACKAGE="libjpeg-turbo"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Edit the Makefile to install docs in a nicer directory
sed -i -e '/^docdir/ s:$:/libjpeg-turbo-1.4.2:' Makefile.in
# Configure the source
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-jpeg8            \
            --disable-static
# Build using the configured sources
make -j "$CORES"
# Install the built package

popd

rm -rf "$FOLD_NAME"
## End script
