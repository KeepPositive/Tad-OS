#! /bin/bash

PACKAGE="automake"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Prevent a warning
sed -i 's:/\\\${:/\\\$\\{:' bin/automake.in
# Configure the source
./configure --prefix=/usr --docdir=/usr/share/doc/automake-$VERSION
# Build using the configured sources
make -j 1
# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]
then
    make install
fi

popd

rm -rf "$FOLD_NAME"
