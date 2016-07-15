#! /bin/bash

PACKAGE=asciidoc
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

tar xf $PACKAGE_DIR/$FOLD_NAME.tar.gz
pushd $FOLD_NAME

./configure --prefix=/usr --sysconfdir=/etc

make -j $CORES

popd
rm -rf $FOLD_NAME
