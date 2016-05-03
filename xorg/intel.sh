#! /bin/bash

PACKAGE="xf86-video-intel"
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"
pushd "$FOLD_NAME"

# Configure the source
./configure $XORG_CONFIG --enable-uxa \
                         --enable-kms-only
                         
# Build using the configured sources
make -j "$CORES"

# Install the built package
# Make sure you have the kernel is configured correctly
if [ "$INSTALL" -eq 1 ]; then
    make install
    printf 'Section "Device"\nIdentifier "Intel Graphics"\nDriver "intel"\nOption "AccelMethod" "uxa"\nEndSection'
fi

popd
rm -rf "$FOLD_NAME"
