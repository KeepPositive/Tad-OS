#! /bin/bash

PACKAGE="man-db"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr                        \
            --docdir=/usr/share/doc/man-db-2.7.5 \
            --sysconfdir=/etc                    \
            --disable-setuid                     \
            --with-browser=/usr/bin/lynx         \
            --with-vgrind=/usr/bin/vgrind        \
            --with-grap=/usr/bin/grap
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]; then
    make install
    sed -i "s:man root:root root:g" /usr/lib/tmpfiles.d/man-db.conf
fi

popd

rm -rf "$FOLD_NAME"
