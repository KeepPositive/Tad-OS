#! /bin/bash

PACKAGE="intltool"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Prevent a warning later on
sed -i 's:\\\${:\\\$\\{:' intltool-update.in
# Configure the source
./configure --prefix=/usr
# Build using the configured sources
make -j "$CORES"
# Install the built package

popd

rm -rf "$FOLD_NAME"
