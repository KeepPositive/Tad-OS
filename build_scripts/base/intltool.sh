#! /bin/bash

PACKAGE="intltool"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Prevent a warning later on
sed -i 's:\\\${:\\\$\\{:' intltool-update.in
# Configure the source
./configure --prefix=/usr
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL" -eq 1 ]; then
    make install
    install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-$VERSION/I18N-HOWTO
fi

popd

rm -rf "$FOLD_NAME"
