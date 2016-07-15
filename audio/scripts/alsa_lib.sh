#! /bin/bash

## Start variables
NAME='alsa-lib'
EXTENSION='.tar.bz2'
PACKAGE=$(ls --ignore='*.patch' ./sources/ | grep -m 1 "$NAME-*")
FOLD_NAME=$(echo "$PACKAGE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
tar xf "$PACKAGE_DIR/$PACKAGE"

pushd "$FOLD_NAME"

# Configure the source
./configure
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
