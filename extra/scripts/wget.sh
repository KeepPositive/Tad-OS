#! /bin/bash

PACKAGE=wget
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

tar xf $PACKAGE_DIR/$FOLD_NAME.tar.xz
pushd $FOLD_NAME

# Configure the source
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-ssl=openssl
# Build using the configured sources
make -j $CORES
# Install the built package
popd
rm -rf $FOLD_NAME
