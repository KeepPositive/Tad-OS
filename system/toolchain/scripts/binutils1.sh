#! /bin/bash

PACKAGE="binutils"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
BUILD_DIR="$LFS/$FOLD_NAME/build"

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

mkdir "$BUILD_DIR"

pushd "$BUILD_DIR"

# Configure the source
../configure --prefix=/tools            \
             --with-sysroot="$LFS"      \
             --with-lib-path=/tools/lib \
             --target="$LFS_TGT"        \
             --disable-nls              \
             --disable-werror

# Build using the configured sources
make -j "$CORES"

# Install the built package
                ln -sv lib /tools/lib64
        ;;
    esac
    make install
fi

popd

rm -rf "$FOLD_NAME"
