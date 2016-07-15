#! /bin/bash

PACKAGE="gettext"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"


tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"
pushd "$FOLD_NAME"

# Configure the source
cd gettext-tools
EMACS="no" ./configure --prefix=/tools --disable-shared

# Build using the configured sources
make -C gnulib-lib
make -C intl pluralx.c
make -C src msgfmt
make -C src msgmerge
make -C src xgettext

# Install the built package

popd
rm -rf "$FOLD_NAME"
