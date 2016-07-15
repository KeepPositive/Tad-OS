#! /bin/bash

PACKAGE="p7zip"
VERSION=$1
FOLD_NAME=$PACKAGE"_$VERSION"

echo "$FOLD_NAME"

tar xf "$PACKAGE_DIR/${PACKAGE}_${VERSION}_src_all.tar.bz2"
pushd "$FOLD_NAME"

# Build using the configured sources
# We don't use 'make all3' because RAR is a propritary format
make -j $CORES all
# Install the built package
fi

popd
rm -rf "$FOLD_NAME"
