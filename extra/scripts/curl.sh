#! /bin/bash

PACKAGE=curl
VERSION=$1
FOLD_NAME=curl-curl-$VERSION

tar xf $PACKAGE_DIR/curl-$VERSION.tar.gz
pushd $FOLD_NAME

# Configure the source
./buildconf # Kinda like an autogen script
./configure --prefix=/usr              \
            --disable-static           \
            --enable-threaded-resolver
# Build using the configured sources
make -j $CORES
# Install the built package
    rm -rf docs/examples/.deps

    find docs \( -name Makefile\* \
              -o -name \*.1       \
              -o -name \*.3 \)    \
              -exec rm {} \;
    install -v -d -m755 /usr/share/doc/curl-$VERSION
    cp -v -R docs/* /usr/share/doc/curl-$VERSION
    rm -rf docs
    mv -i docs-save doc
fi

popd

rm -rf $FOLD_NAME
