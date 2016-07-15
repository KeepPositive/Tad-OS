#! /bin/bash

PACKAGE="perl"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"
pushd "$FOLD_NAME"

# Configure the source
sh Configure -des -Dprefix=/tools -Dlibs=-lm

# Build using the configured sources
make -j "$CORES"

# Install the built package
fi

popd
rm -rf "$FOLD_NAME"
