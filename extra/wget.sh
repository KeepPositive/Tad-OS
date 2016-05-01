#! /bin/bash

PACKAGE=wget
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

if [ -z $CORES]; then
	CORES = '4'
fi

tar xf $PACKAGE_DIR/$FOLD_NAME.tar.xz
pushd $FOLD_NAME

# Configure the source
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-ssl=openssl
# Build using the configured sources
make -j $CORES
# Install the built package
if [ $INSTALL -eq 1 ]; then
    make install
fi

popd
rm -rf $FOLD_NAME
