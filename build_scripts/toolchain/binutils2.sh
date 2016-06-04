#! /bin/bash

PACKAGE="binutils"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
BUILD_DIR="$LFS/$FOLD_NAME/build"

if [ -z "$CORES" ]
then
	CORES=4
fi

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

mkdir "$BUILD_DIR"

pushd "$BUILD_DIR"

# Configure the source
CC=$LFS_TGT-gcc                \
AR=$LFS_TGT-ar                 \
RANLIB=$LFS_TGT-ranlib         \
../configure                   \
    --prefix=/tools            \
    --disable-nls              \
    --disable-werror           \
    --with-lib-path=/tools/lib \
    --with-sysroot

# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]
then
    make install
	make -C ld clean
	make -C ld LIB_PATH=/usr/lib:/lib
	cp -v ld/ld-new /tools/bin
fi

popd

rm -rf "$FOLD_NAME"
