#! /bin/bash

PACKAGE="xorg-server"
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"
pushd "$FOLD_NAME"

# Configure the source
           --enable-glamor          \
           --enable-install-setuid  \
           --enable-suid-wrapper    \
           --enable-kdrive          \
           --with-xkb-output=/var/lib/xkb

# Build using the configured sources
make -j "$CORES"

# Install the built package
        "/tmp/.X11-unix dir 1777 root root" > /etc/sysconfig/createfiles

fi

popd
rm -rf "$FOLD_NAME"
