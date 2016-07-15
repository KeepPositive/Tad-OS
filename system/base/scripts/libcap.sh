#! /bin/bash

PACKAGE="libcap"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Disable static libraries 
sed -i '/install.*STALIBNAME/d' libcap/Makefile
# Build using the configured sources
make -j "$CORES"
# Install the built package
    ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so
fi

popd

rm -rf "$FOLD_NAME"
