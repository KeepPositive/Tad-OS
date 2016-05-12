#! /bin/bash

PACKAGE="gcc"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
BUILD_DIR="$LFS/$FOLD_NAME/build"
MPFR_VER=$2
GMP_VER=$3
MPC_VER=$4

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

pushd "$FOLD_NAME"

case $SYSTEM in
"rpi")
    patch -Np1 -i "$PACKAGE_DIR/gcc-5.3.0-rpi3-cpu-default.patch"
;;
esac

#  GCC needs some libraries while installing, so extract them and move them to
# the correct directories where GCC can find them.
tar -xf "$PACKAGE_DIR/mpfr-$MPFR_VER.tar.xz"
mv -v "mpfr-$MPFR_VER" mpfr

tar -xf "$PACKAGE_DIR/gmp-$GMP_VER.tar.xz"
mv -v "gmp-$GMP_VER" gmp

tar -xf "$PACKAGE_DIR/mpc-$MPC_VER.tar.gz"
mv -v "mpc-$MPC_VER" mpc

case $SYSTEM in
"rpi")
    for file in \
		$(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h -o -name linux-eabi.h -o -name linux-elf.h)
    do
        cp -uv $file{,.orig}
        sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
            -e 's@/usr@/tools@g' $file.orig > $file
        echo '#undef STANDARD_STARTFILE_PREFIX_1
              #undef STANDARD_STARTFILE_PREFIX_2
              #define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
              #define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
        touch $file.orig
    done
;;

*)
    for file in \
        $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
    do
        cp -uv "$file"{,.orig}
        sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
            -e 's@/usr@/tools@g' "$file.orig" > "$file"
        echo '#undef STANDARD_STARTFILE_PREFIX_1
              #undef STANDARD_STARTFILE_PREFIX_2
              #define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
              #define STANDARD_STARTFILE_PREFIX_2 ""' >> "$file"
        touch "$file.orig"
    done
;;
esac

popd

mkdir "$BUILD_DIR"

pushd "$BUILD_DIR"

# Configure the source
../configure                                       \
    --target=$LFS_TGT                              \
    --prefix=/tools                                \
    --with-glibc-version=2.11                      \
    --with-sysroot=$LFS                            \
    --with-newlib                                  \
    --without-headers                              \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --disable-nls                                  \
    --disable-shared                               \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libmpx                               \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++

# Edit the Makefile to prevent a Pi build error
case $SYSTEM in
"rpi")
    sed -i 's/none-/armv6l-/' Makefile
    sed -i 's/none-/armv7l-/' Makefile
;;
esac

# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL" -eq 1 ]
then
    make install
fi

popd

rm -rf "$FOLD_NAME"
