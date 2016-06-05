#! /bin/bash

PACKAGE="xf86-video-fbturbo"
VERSION=$1

if [ -z "$CORES" ]
then
	CORES=4
fi

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
if [ "$INSTALL" -eq 1 ]
then
    make install
fi

popd
rm -rf "$PACKAGE"
