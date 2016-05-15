#! /bin/bash

PACKAGE=""
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr --disable-static
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL" -eq 1 ]; then
    make install
	install -v -dm755 /usr/share/doc/expat-$VERSION
	install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-$VERSION
fi

popd

rm -rf "$FOLD_NAME"
