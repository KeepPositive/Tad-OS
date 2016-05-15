#! /bin/bash

PACKAGE="linux"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"
pushd "$FOLD_NAME"

# Clean the sources
make mrproper

# Install the built package
if [ "$INSTALL" -eq 1 ]
then
    make INSTALL_HDR_PATH=dest headers_install
    find dest/include \( -name .install -o -name ..install.cmd \) -delete
    cp -rv dest/include/* /usr/include
fi

popd

rm -rf "$FOLD_NAME"
