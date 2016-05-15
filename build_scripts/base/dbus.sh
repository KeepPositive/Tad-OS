#! /bin/bash

PACKAGE="dbus"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"
# Configure the source
./configure --prefix=/usr                           \
              --sysconfdir=/etc                     \
              --localstatedir=/var                  \
              --disable-static                      \
              --disable-doxygen-docs                \
              --disable-xml-docs                    \
              --docdir=/usr/share/doc/dbus-$VERSION \
              --with-console-auth-dir=/run/console
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL" -eq 1 ]; then
    make install
    mv -v /usr/lib/libdbus-1.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libdbus-1.so) /usr/lib/libdbus-1.so
    ln -sfv /etc/machine-id /var/lib/dbus
fi

popd

rm -rf "$FOLD_NAME"
