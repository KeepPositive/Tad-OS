#! /bin/bash

PACKAGE=pcre
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

if [ -z $CORES]; then
	CORES = '4'
fi

tar xf $PACKAGE_DIR/$FOLD_NAME.tar.bz2
pushd $FOLD_NAME

# Configure the source
if [ -f ../pcre-$VERSION-upstream_fixes-1.patch ]; then
    patch -Np1 -i ../pcre-8.38-upstream_fixes-1.patch
fi
./configure --prefix=/usr                     \
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
if [ $INSTALL -eq 1 ]; then
    make install
    mv -v /usr/lib/libpcre.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libpcre.so) /usr/lib/libpcre.so
fi

popd
rm -rf $FOLD_NAME
