#! /bin/bash

## Start variables
NAME='gcc'
EXTENSION='.tar.bz2'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Apply a patch for the RPi
case $SYSTEM in
"rpi")
  patch -Np1 -i "$PACKAGE_DIR/gcc-5.3.0-rpi3-cpu-default.patch"
;;
esac
# Extract a few other packages into the GCC sources
MPFR_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "mpfr-*")
MPFR_FOLDER=$(echo "$MPFR_FOLDER" | sed -e "s/.tar.xz//")
tar xvf "$SOURCE_DIR/$MPFR_FILE"
mv -v "$MPFR_FOLDER"
# More packages
GMP_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "gmp-*")
GMP_FOLDER=$(echo "$GMP_FILE" | sed -e "s/.tar.xz//")
tar xvf "$SOURCE_DIR/$GMP_FILE"
mv -v "$GMP_FOLDER"
# Last package
MPC_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "mpc-*")
MPC_FOLDER=$(echo "$MPC_FILE" | sed -e "s/.tar.gz//")
tar xvf "$SOURCE_DIR/$MPC_FILE"
mv -v "$MPC_FOLDER"
# Write some config files
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
# Leave the source directory
popd
# Make a build directory
mkdir "$FOLDER_NAME/build"
#Enter the build directory
pushd "$FOLDER_NAME/build"
# Configure the source
C=$LFS_TGT-gcc                                              \
CXX=$LFS_TGT-g++                                            \
AR=$LFS_TGT-ar                                              \
RANLIB=$LFS_TGT-ranlib                                      \
../configure --prefix=/tools                                \
             --with-local-prefix=/tools                     \
             --with-native-system-header-dir=/tools/include \
             --enable-languages=c,c++                       \
             --disable-libstdcxx-pch                        \
             --disable-multilib                             \
             --disable-bootstrap                            \
             --disable-libgomp
 # Edit the Makefile to prevent a Pi build error
 case $SYSTEM in
 "rpi")
   sed -i 's/none-/armv6l-/' Makefile
 ;;
 esac
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
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
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
