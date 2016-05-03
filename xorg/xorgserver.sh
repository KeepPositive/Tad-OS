#! /bin/bash

PACKAGE="xorg-server"
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"
pushd "$FOLD_NAME"

# Configure the source
if [ "$VERSION" -eq "1.18.3" ]; then
    patch -Np1 -i ../xorg-server-1.18.3-add_prime_support-1.patch
fi
./configure $XORG_CONFIG            \
           --enable-glamor          \
           --enable-install-setuid  \
           --enable-suid-wrapper    \
           --enable-kdrive          \
           --with-xkb-output=/var/lib/xkb

# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL" -eq 1 ]; then
    make install
    mkdir -pv /etc/X11/xorg.conf.d
    printf '%s\n%s\n', "/tmp/.ICE-unix dir 1777 root root" \
        "/tmp/.X11-unix dir 1777 root root" > /etc/sysconfig/createfiles

fi

popd
rm -rf "$FOLD_NAME"
