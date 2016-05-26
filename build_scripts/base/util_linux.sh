#! /bin/bash

PACKAGE="util-linux"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"
pushd "$FOLD_NAME"

# Configure the source
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime       \
            --docdir=/usr/share/doc/util-linux-$VERSION \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python
# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]; then
    make install
fi

popd
rm -rf "$FOLD_NAME"
