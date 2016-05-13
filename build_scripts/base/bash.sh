#! /bin/bash

PACKAGE="bash"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"
pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/tools --without-bash-malloc

# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL" -eq 1 ]; then
    make install
    ln -sv bash /tools/bin/sh
fi

popd
rm -rf "$FOLD_NAME"