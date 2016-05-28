#! /bin/bash

## Start variables
PACKAGE="setuptools"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]
then
	CORES=4
fi
## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

python2 setup.py install --optimize=1
python3 setup.py install --optimize=1

popd

rm -rf "$FOLD_NAME"
## End script
