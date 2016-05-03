#! /bin/bash

PACKAGE="icu"
VERSION=$1

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/icu4c-$VERSION-src.tgz"
pushd "icu/source"

# Configure the source
CC=gcc CXX=g++ ./configure --prefix=/usr

# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL" -eq 1 ]; then
    make install
fi

popd
rm -rf "icu"
