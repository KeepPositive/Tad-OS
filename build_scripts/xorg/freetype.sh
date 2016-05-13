#! /bin/bash

PACKAGE="freetype"
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"
pushd "$FOLD_NAME"

# Configure the source
sed -e "/AUX.*.gxvalid/s@^# @@" \
    -e "/AUX.*.otvalid/s@^# @@" \
    -i modules.cfg

sed -r -e 's:.*(#.*SUBPIXEL.*) .*:\1:' \
    -i include/freetype/config/ftoption.h

./configure --prefix=/usr --disable-static

# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ $INSTALL -eq 1 ]; then
	
	make install
	
	install -v -m755 -d /usr/share/doc/freetype-$VERSION
	
	cp -v -R docs/*     /usr/share/doc/freetype-$VERSION
fi

popd
rm -rf $FOLD_NAME
