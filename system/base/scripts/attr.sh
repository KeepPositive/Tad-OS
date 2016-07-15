#! /bin/bash

PACKAGE="attr"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xf "$PACKAGE_DIR/$FOLD_NAME.src.tar.gz"

pushd "$FOLD_NAME"

# Configure the source
sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
sed -i -e "/SUBDIRS/s|man[25]||g" man/Makefile
./configure --prefix=/usr --disable-static
# Build using the configured sources
make -j "$CORES"

# Install the built package
    ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so
fi

popd

rm -rf "$FOLD_NAME"
