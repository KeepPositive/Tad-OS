#! /bin/bash

PACKAGE="llvm"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION.src"

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"
pushd "$FOLD_NAME"

# Configure the source
mkdir -v build
cd build

CC=gcc CXX=g++                              \
cmake -DCMAKE_INSTALL_PREFIX=/usr           \
      -DLLVM_ENABLE_FFI=ON                  \
      -DCMAKE_BUILD_TYPE=Release            \
      -DBUILD_SHARED_LIBS=ON                \
      -DLLVM_TARGETS_TO_BUILD="host;AMDGPU" \
      -Wno-dev ..

# Build using the configured sources
make -j "$CORES"

# Install the built package
cd ..
popd
rm -rf "$FOLD_NAME"
