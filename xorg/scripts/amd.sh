#! /bin/bash

PACKAGE="xf86-video-ati"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
CONFIGURE_EXTRA_FIRMWARE=""
CONFIGURE_EXTRA_FIRMWARE_DIR="/lib/firmware"
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"
pushd "$FOLD_NAME"

# Configure the source
./configure $XORG_CONFIG

# Build using the configured sources
make -j "$CORES"

# Install the built package
           "$XORG_PREFIX/share/X11/xorg.conf.d/20-glamor.conf"
fi

popd
rm -rf "$FOLD_NAME"
