#! /bin/bash

PACKAGE="psmisc"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL" -eq 1 ]; then
    make install
    mv -v /usr/bin/fuser /bin
    mv -v /usr/bin/killall /bin
fi

popd

rm -rf "$FOLD_NAME"