#! /bin/bash

PACKAGE="ncurses"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Configure the source
sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec
# Build using the configured sources
make -j "$CORES"
# Install the built package
    for lib in ncurses form panel menu
    do
        rm -vf /usr/lib/lib${lib}.so
        echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
        ln -sfv ${lib}w.pc /usr/lib/pkgconfig/${lib}.pc
    done
    rm -vf /usr/lib/libcursesw.so
    echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
    ln -sfv libncurses.so /usr/lib/libcurses.so
    # Install documentation
    mkdir -v /usr/share/doc/ncurses-$VERSION
    cp -v -R doc/* /usr/share/doc/ncurses-$VERSION
fi

popd

rm -rf "$FOLD_NAME"
