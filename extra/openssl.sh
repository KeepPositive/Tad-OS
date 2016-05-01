#! /bin/bash

PACKAGE=openssl
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

if [ -z $CORES]; then
	CORES = '4'
fi

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
if [ $INSTALL -eq 1 ]; then
    sed -i 's# libcrypto.a##;s# libssl.a##' Makefile # Disable static libraries
    make MANDIR=/usr/share/man MANSUFFIX=ssl install
    install -dv -m755 /usr/share/doc/openssl-$VERSION
    cp -vfr doc/* /usr/share/doc/openssl-$VERSION
fi
popd
rm -rf $FOLD_NAME
