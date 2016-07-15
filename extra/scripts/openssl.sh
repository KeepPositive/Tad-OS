#! /bin/bash

PACKAGE=openssl
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

tar xf $PACKAGE_DIR/$FOLD_NAME.tar.gz
pushd $FOLD_NAME

# Configure the source
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic          \
         no-rc5                \
         no-idea
# Build using the configured sources
make -j $CORES depend
make -j $CORES
# Install the built package
    cp -vfr doc/* /usr/share/doc/openssl-$VERSION
fi
popd
rm -rf $FOLD_NAME
