#! /bin/bash

PACKAGE="gzip"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Configure the source

# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]; then
    make install
    mv -v /bin/{gzexe,uncompress,zcmp,zdiff,zegrep} /usr/bin
    mv -v /bin/{zfgrep,zforce,zgrep,zless,zmore,znew} /usr/bin
fi

popd

rm -rf "$FOLD_NAME"
