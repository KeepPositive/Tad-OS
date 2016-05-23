#! /bin/bash

PACKAGE="gettext"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-$VERSION
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]; then
    make install
    chmod -v 0755 /usr/lib/preloadable_libintl.so
fi

popd

rm -rf "$FOLD_NAME"
