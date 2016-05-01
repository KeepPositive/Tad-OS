#! /bin/bash

PACKAGE=libffi
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

if [ -z $CORES]; then
	CORES = '4'
fi

tar xf $PACKAGE_DIR/$FOLD_NAME.tar.gz
pushd $FOLD_NAME

# Configure the source
sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
    -i include/Makefile.in
sed -e '/^includedir/ s/=.*$/=@includedir@/' \
    -e 's/^Cflags: -I${includedir}/Cflags:/' \
    -i libffi.pc.in
./configure --prefix=/usr --disable-static
# Build using the configured sources
make -j $CORES
# Install the built package
if [ $INSTALL -eq 1 ]; then
    make install
fi

popd
rm -rf $FOLD_NAME
