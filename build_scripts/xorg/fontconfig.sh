#! /bin/bash

PACKAGE="fontconfig"
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"
pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-docs       \
            --docdir="/usr/share/doc/fontconfig-$VERSION"

# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL" -eq 1 ]; then
    make install
    install -v -dm755 \
            /usr/share/{man/man{3,5},doc/fontconfig-2.11.1/fontconfig-devel}
    install -v -m644 fc-*/*.1          /usr/share/man/man1
    install -v -m644 doc/*.3           /usr/share/man/man3
    install -v -m644 doc/fonts-conf.5  /usr/share/man/man5
    install -v -m644 doc/fontconfig-devel/* \
            /usr/share/doc/"fontconfig-$VERSION"/fontconfig-devel
    install -v -m644 doc/*.{pdf,sgml,txt,html} \
           /usr/share/doc/"fontconfig-$VERSION"
fi

popd
rm -rf "$FOLD_NAME"
