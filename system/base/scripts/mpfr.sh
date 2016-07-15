#! /bin/bash

PACKAGE="mpfr"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"
pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.1.0
# Build using the configured sources
make -j "$CORES"
#make -j "$CORES" html
# Install the built package

popd

rm -rf "$FOLD_NAME"
