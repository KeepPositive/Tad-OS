#! /bin/bash

PACKAGE="tcl-core"
VERSION=$1
FOLD_NAME="$PACKAGE$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xvf "$PACKAGE_DIR/$PACKAGE$VERSION-src.tar.gz"

pushd "tcl$VERSION/unix"

# Configure the source
./configure --prefix=/tools

# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL" -eq 1 ]; then
    make install
	chmod -v u+w /tools/lib/libtcl8.6.so
	make install-private-headers
	ln -sfv tclsh8.6 /tools/bin/tclsh
fi

popd

rm -rf "tcl$VERSION/unix"
