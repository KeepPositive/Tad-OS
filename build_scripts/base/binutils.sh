#! /bin/bash

PACKAGE="binutils"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
BUILD_DIR="/$FOLD_NAME/build"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

pushd "$FOLD_NAME"
# Verify some things using expect
expect -c "spawn ls"
# Apply this patch
patch -Np1 -i "$PACKAGE_DIR/binutils-2.26-upstream_fixes-3.patch"
popd

mkdir "$BUILD_DIR"

pushd "$BUILD_DIR"

# Configure the source
../configure --prefix=/usr   \
             --enable-shared \
             --disable-werror
# Build using the configured sources
make -j "$CORES" tooldir=/usr  
# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]
then
    make tooldir=/usr install
fi
# Exit the build dir
popd
# Remove the source code directory
rm -rf "$FOLD_NAME"
