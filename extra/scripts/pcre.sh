#! /bin/bash

PACKAGE=pcre
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

tar xf $PACKAGE_DIR/$FOLD_NAME.tar.bz2
pushd $FOLD_NAME

# Configure the source
            --docdir=/usr/share/doc/pcre-8.38 \
            --enable-unicode-properties       \
            --enable-pcre16                   \
            --enable-pcre32                   \
            --enable-pcregrep-libz            \
            --enable-pcregrep-libbz2          \
            --enable-pcretest-libreadline     \
            --disable-static
# Build using the configured sources
make -j $CORES
# Install the built package
fi

popd
rm -rf $FOLD_NAME
