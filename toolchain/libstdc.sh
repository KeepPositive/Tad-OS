#! /bin/bash

PACKAGE="gcc"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
BUILD_DIR="$FOLD_NAME/build"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

mkdir "$BUILD_DIR"

pushd "$BUILD_DIR"

# Configure the source
../libstdc++-v3/configure           \
    --host="$LFS_TGT"               \
    --prefix=/tools                 \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-threads     \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir="/tools/$LFS_TGT/include/c++/$VERSION"

# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL" -eq 1 ]; then
    make install
fi

popd

rm -rf "$FOLD_NAME"
