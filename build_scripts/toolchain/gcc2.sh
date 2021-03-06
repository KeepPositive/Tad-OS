#! /bin/bash

PACKAGE="gcc"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
BUILD_DIR="$LFS/$FOLD_NAME/build"
MPFR_VER=$2
GMP_VER=$3
MPC_VER=$4

if [ -z "$CORES" ]
then
	CORES=4
fi

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

pushd "$FOLD_NAME"

case $SYSTEM in
"rpi")
    patch -Np1 -i "$PACKAGE_DIR/gcc-5.3.0-rpi3-cpu-default.patch"
;;
esac

#  GCC needs some libraries here while installing, so extract them and move
# them to the correct directories where GCC can find them.
tar -xf "$PACKAGE_DIR/mpfr-$MPFR_VER.tar.xz"
mv -v "mpfr-$MPFR_VER" mpfr

tar -xf "$PACKAGE_DIR/gmp-$GMP_VER.tar.xz"
mv -v "gmp-$GMP_VER" gmp

tar -xf "$PACKAGE_DIR/mpc-$MPC_VER.tar.gz"
mv -v "mpc-$MPC_VER" mpc

case $SYSTEM in
"rpi")
    
    cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
        `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h
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
CC=$LFS_TGT-gcc                                    \
CXX=$LFS_TGT-g++                                   \
AR=$LFS_TGT-ar                                     \
RANLIB=$LFS_TGT-ranlib                             \
../configure                                       \
    --prefix=/tools                                \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --enable-languages=c,c++                       \
    --disable-libstdcxx-pch                        \
    --disable-multilib                             \
    --disable-bootstrap                            \
    --disable-libgomp

case $SYSTEM in
"rpi")
    sed -i 's/none-/armv6l-/' Makefile
;;
esac

# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]
then
    make install
	# Create a symbolic link between gcc and cc
	ln -sfv gcc /tools/bin/cc
    # Run a small test to ensure everything is working just fine
	echo 'int main(){}' > dummy.c
	cc dummy.c
	readelf -l a.out | grep ': /tools'
fi

popd

rm -rf "$FOLD_NAME"
