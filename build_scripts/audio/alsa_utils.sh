#! /bin/bash

## Start variables
PACKAGE="alsa-utils"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]
then
	CORES=4
fi
## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

pushd "$FOLD_NAME"

# Configure the source
./configure --disable-alsaconf  \
            --disable-bat       \
            --disable-xmlto     \
            --with-curses=ncursesw
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL" -eq 1 ]
then
    make install
fi

popd

rm -rf "$FOLD_NAME"
## End script
