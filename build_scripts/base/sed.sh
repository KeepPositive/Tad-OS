#! /bin/bash

PACKAGE="sed"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr --bindir=/bin --htmldir=/usr/share/doc/sed-$VERSION
# Build using the configured sources
make -j "$CORES"
#make -j "$CORES" html
# Install the built package
if [ "$INSTALL" -eq 1 ]; then
    make install
    #make -C doc install-html
fi

popd

rm -rf "$FOLD_NAME"
