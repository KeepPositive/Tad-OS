#! /bin/bash

PACKAGE="libcap"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Disable static libraries 
sed -i '/install.*STALIBNAME/d' libcap/Makefile
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL" -eq 1 ]; then
    make RAISE_SETFCAP=no prefix=/usr install
    chmod -v 755 /usr/lib/libcap.so
    mv -v /usr/lib/libcap.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so
fi

popd

rm -rf "$FOLD_NAME"
