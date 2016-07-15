#! /bin/bash

## Start variables
PACKAGE="libvpx"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
BUILD_DIR="$FOLD_NAME/libvpx-build"

## End variables

## Start script
tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

pushd "$FOLD_NAME"

# Correct some file permission on install
sed -i 's/cp -p/cp/' build/make/Makefile

           /usr/bin/arm-none-gnueabi-gcc
    ln -sv /usr/bin/as /usr/bin/arm-none-gnueabi-as
;;
esac

popd

# Enter a build directory
mkdir $BUILD_DIR
pushd $BUILD_DIR
# Configure the source
../configure --prefix=/usr            \
             --enable-shared          \
             --disable-static
# Build using the configured sources
make -j "$CORES"
# Install the built package

popd

rm -rf "$FOLD_NAME"
## End script
