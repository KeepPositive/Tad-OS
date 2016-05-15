#! /bin/bash

PACKAGE="xz"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

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
if [ "$INSTALL" -eq 1 ]; then
    make install
    mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
    mv -v /usr/lib/liblzma.so.* /lib
    ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so
fi

popd

rm -rf "$FOLD_NAME"
