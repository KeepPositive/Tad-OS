#! /bin/bash

PACKAGE=libpng
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

if [ -z "$CORES" ]
then
    CORES=4
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"
pushd "$FOLD_NAME"

# Configure the source
gzip -cd "$PACKAGE_DIR/libpng-$VERSION-apng.patch.gz" | patch -p0
./configure --prefix=/usr --disable-static

# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL" -eq 1 ]
then
    make install
    mkdir -v "/usr/share/doc/libpng-$VERSION"
    cp -v README libpng-manual.txt "/usr/share/doc/libpng-$VERSION"
fi

popd
rm -rf $FOLD_NAME
