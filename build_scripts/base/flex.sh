#! /bin/bash

PACKAGE="flex"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr --docdir=/usr/share/doc/flex-$VERSION
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]; then
    make install
    ln -sv flex /usr/bin/lex
fi

popd

rm -rf "$FOLD_NAME"
