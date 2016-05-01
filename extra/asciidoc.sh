#! /bin/bash

PACKAGE=asciidoc
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

if [ -z $CORES]; then
	CORES = '4'
fi

tar xf $PACKAGE_DIR/$FOLD_NAME.tar.gz
pushd $FOLD_NAME

./configure --prefix=/usr --sysconfdir=/etc

make -j $CORES

if [ $INSTALL -eq 1 ]; then
    make install
fi

popd
rm -rf $FOLD_NAME
