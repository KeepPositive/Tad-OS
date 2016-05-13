#! /bin/bash

PACKAGE="zlib"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"
# Configure the source
./configure --prefix=/usr

# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL" -eq 1 ]; then
    make install
	mv -v /usr/lib/libz.so.* /lib
	ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so
fi

popd

rm -rf "$FOLD_NAME"
