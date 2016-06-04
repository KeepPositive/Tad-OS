#! /bin/bash

# Needs curl

PACKAGE=cmake
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

if [ -z "$CORES" ]
then
	CORES=4
fi

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
if [ $INSTALL -eq 1 ]
then
    make install
fi

popd
rm -rf $FOLD_NAME
