#! /bin/bash

PACKAGE="p7zip"
VERSION=$1
FOLD_NAME=$PACKAGE"_$VERSION"

echo "$FOLD_NAME"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/${PACKAGE}_{$VERSION}_src_all.tar.bz2"
pushd "$FOLD_NAME"

# Build using the configured sources
# We don't use 'make all3' because RAR is a propritary format
make -j $CORES all
# Install the built package
if [ "$INSTALL" -eq 1 ]; then
    make DEST_HOME=/usr \
         DEST_MAN=/usr/share/man \
         DEST_SHARE_DOC="/usr/share/doc/p7zip-$VERSION" install
fi

popd
rm -rf "$FOLD_NAME"
