#! /bin/bash

PACKAGE="diffutils"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Prevent errors
sed -i 's:= @mkdir_p@:= /bin/mkdir -p:' po/Makefile.in.in
# Configure the source
./configure --prefix=/usr
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]; then
    make install
fi

popd

rm -rf "$FOLD_NAME"
