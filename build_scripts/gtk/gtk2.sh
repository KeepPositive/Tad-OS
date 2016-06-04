#! /bin/bash

## Start variables
PACKAGE="gtk+"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]
then
	CORES=4
fi
## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"
# Edit the Makefile to prevent a documentation error
sed -i "s#l \(gtk-.*\).sgml#& -o \1#" docs/{faq,tutorial}/Makefile.in
# Configure the source
./configure --prefix=/usr --sysconfdir=/etc
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL" -eq 1 ]
then
    make install
    gtk-query-immodules-2.0 --update-cache
fi

popd

rm -rf "$FOLD_NAME"
## End script
