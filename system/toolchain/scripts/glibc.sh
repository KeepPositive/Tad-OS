#! /bin/bash

## Start variables
NAME='glibc'
EXTENSION='.tar.xz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Apply a patch
patch -Np1 -i "$SOURCE_DIR/glibc-2.23-upstream_fixes-1.patch"
# Leave the source directory
popd
# Make a build directory
mkdir "$FOLDER_NAME/build"
#Enter the build directory
pushd "$FOLDER_NAME/build"
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
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  # According to PiLFS, this symbolic link is needed.
  case $SYSTEM in
  "rpi")
    ln -sfv ld-2.23.so "$LFS/tools/lib/ld-linux.so.3"
  ;;
  esac
  # Run a small test to see if everything is going okay
  echo 'int main(){}' > dummy.c
  "$LFS_TGT-gcc" dummy.c
  readelf -l a.out | grep ': /tools'
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
