#! /bin/bash

PACKAGE="icu"
VERSION=$1

tar xf "$PACKAGE_DIR/icu4c-$VERSION-src.tgz"
pushd "icu/source"

# Configure the source
CC=gcc CXX=g++ ./configure --prefix=/usr

# Build using the configured sources
make -j "$CORES"

# Install the built package
popd
rm -rf "icu"
