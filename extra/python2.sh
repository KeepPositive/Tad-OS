#! /bin/bash

PACKAGE=Python
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

if [ -z $CORES]; then
	CORES = '4'
fi

tar xf $PACKAGE_DIR/$FOLD_NAME.tar.xz
pushd $FOLD_NAME

# Configure the source
./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --enable-unicode=ucs4
# Build using the configured sources
make -j $CORES
# Install the built package
if [ $INSTALL -eq 1 ]; then
    make install
    chmod -v 755 /usr/lib/libpython2.7.so.1.0
fi

popd
rm -rf $FOLD_NAME
