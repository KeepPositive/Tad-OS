#! /bin/bash

PACKAGE="readline"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

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
    ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so
    install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-$VERSION
fi

popd

rm -rf "$FOLD_NAME"
