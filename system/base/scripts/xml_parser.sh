#! /bin/bash

PACKAGE="XML-Parser"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Configure the source
perl Makefile.PL
# Build using the configured sources
make -j "$CORES"
# Install the built package
popd

rm -rf "$FOLD_NAME"
