#! /bin/bash

PACKAGE="glibc"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
BUILD_DIR="$FOLD_NAME/build"

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

patch -Np1 -i "$PACKAGE_DIR/glibc-2.23-upstream_fixes-1.patch"

popd

mkdir "$BUILD_DIR"

pushd "$BUILD_DIR"

# Configure the source
../configure --prefix=/tools                      \
             --host="$LFS_TGT"                    \
             --build="$(../scripts/config.guess)" \
             --enable-kernel=2.6.32               \
             --with-headers=/tools/include        \
             libc_cv_forced_unwind=yes            \
             libc_cv_ctors_header=yes             \
             libc_cv_c_cleanup=yes

# Build using the configured sources
make -j "$CORES"

# Install the built package
    # According to PiLFS, this symbolic link is needed.
    case $SYSTEM in

    "rpi")
        ln -sfv ld-2.23.so "$LFS/tools/lib/ld-linux.so.3"
    ;;

    esac
    

    else
        echo "WOOPS, test failed..."
        exit 1
    fi
fi

popd

rm -rf "$FOLD_NAME"
