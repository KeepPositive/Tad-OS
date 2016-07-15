#! /bin/bash

PACKAGE="tcl-core"
VERSION=$1
FOLD_NAME="$PACKAGE$VERSION"

tar xvf "$PACKAGE_DIR/$PACKAGE$VERSION-src.tar.gz"

pushd "tcl$VERSION/unix"

# Configure the source
./configure --prefix=/tools

# Build using the configured sources
make -j "$CORES"

# Install the built package
	ln -sfv tclsh8.6 /tools/bin/tclsh
fi

popd

rm -rf "tcl$VERSION"
