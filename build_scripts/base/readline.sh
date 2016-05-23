#! /bin/bash

PACKAGE="readline"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Configure the source
patch -Np1 -i "$PACKAGE_DIR/readline-$VERSION-upstream_fixes-3.patch"
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/readline-$VERSION
# Build using the configured sources
make -j "$CORES" SHLIB_LIBS=-lncurses
# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]; then
    make SHLIB_LIBS=-lncurses install
    mv -v /usr/lib/lib{readline,history}.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
    ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so
    install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-$VERSION
fi

popd

rm -rf "$FOLD_NAME"
