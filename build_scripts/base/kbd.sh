#! /bin/bash

PACKAGE="kbd"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"
# Apply a patch
patch -Np1 -i ../kbd-$VERSION-backspace-1.patch
# Remove a useless program build
sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
# Configure the source
PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr --disable-vlock
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL" -eq 1 ]; then
    make install
    mkdir -v /usr/share/doc/kbd-$VERSION
    cp -R -v docs/doc/* /usr/share/doc/kbd-$VERSION
fi

popd

rm -rf "$FOLD_NAME"
