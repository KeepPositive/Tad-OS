#! /bin/bash

PACKAGE="Python"
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --enable-unicode=ucs4
# Build using the configured sources
make -j $CORES
# Install the built package
fi

popd

rm -rf $FOLD_NAME
