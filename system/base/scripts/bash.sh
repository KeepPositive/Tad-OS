#! /bin/bash

PACKAGE="bash"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Apply a patch
patch -Np1 -i "$PACKAGE_DIR/bash-4.3.30-upstream_fixes-3.patch"
# Configure the source
./configure --prefix=/usr                       \
            --docdir=/usr/share/doc/bash-4.3.30 \
            --without-bash-malloc               \
            --with-installed-readline
# Build using the configured sources
make -j "$CORES"
# Install the built package

popd

rm -rf "$FOLD_NAME"
