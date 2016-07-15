#! /bin/bash

PACKAGE="xf86-video-fbturbo"
VERSION=$1


# Pull the fbturbo repository
git clone https://github.com/ssvb/xf86-video-fbturbo.git

# Change to the source directory
pushd "$PACKAGE"

# Configure the source
./autogen.sh
./configure $XORG_CONFIG

# Build using the configured sources
make -j "$CORES"

# Install the built package

popd
rm -rf "$PACKAGE"
