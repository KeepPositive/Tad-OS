#! /bin/bash

PACKAGE="xz"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Prevent an error
sed -e '/mf\.buffer = NULL/a next->coder->mf.size = 0;' \
    -i src/liblzma/lz/lz_encoder.c
# Configure the source
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-$VERSION
# Build using the configured sources
make -j "$CORES"
# Install the built package
    ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so
fi

popd

rm -rf "$FOLD_NAME"
