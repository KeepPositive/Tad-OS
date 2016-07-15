#! /bin/bash

PACKAGE="gcc"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
BUILD_DIR="$LFS/$FOLD_NAME/build"


tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

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

popd

rm -rf "$FOLD_NAME"
