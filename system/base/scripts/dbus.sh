#! /bin/bash

PACKAGE="dbus"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

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
    ln -sfv /etc/machine-id /var/lib/dbus
fi

popd

rm -rf "$FOLD_NAME"
