#! /bin/bash

PACKAGE=libpng
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION


tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"
pushd "$FOLD_NAME"

# Configure the source
gzip -cd "$PACKAGE_DIR/libpng-$VERSION-apng.patch.gz" | patch -p0
./configure --prefix=/usr --disable-static

# Build using the configured sources
make -j "$CORES"

# Install the built package
    cp -v README libpng-manual.txt "/usr/share/doc/libpng-$VERSION"
fi

popd
rm -rf $FOLD_NAME
