#! /bin/bash

PACKAGE="kmod"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr          \
            --bindir=/bin          \
            --sysconfdir=/etc      \
            --with-rootlibdir=/lib \
            --with-xz              \
            --with-zlib
# Build using the configured sources
make -j "$CORES"
# Install the built package
        ln -sv ../bin/kmod /sbin/$target
    done
    ln -sv kmod /bin/lsmod
fi

popd

rm -rf "$FOLD_NAME"
