#! /bin/bash

# Needs curl

PACKAGE=cmake
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

tar xf $PACKAGE_DIR/$FOLD_NAME.tar.gz
pushd $FOLD_NAME

# Configure the source
./bootstrap --prefix=/usr          \
            --system-libs          \
            --mandir=/share/man    \
            --no-system-jsoncpp    \
            --no-system-libarchive \
            --docdir="/share/doc/cmake-$VERSION"
# Build using the configured sources
make -j "$CORES"
# Install the built package

popd
rm -rf $FOLD_NAME
