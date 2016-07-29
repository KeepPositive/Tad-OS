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
# Add a patch if build on a Raspberry Pi
case $SYSTEM in
"rpi")
  patch -Np1 -i "$PACKAGE_DIR/gcc-5.3.0-rpi3-cpu-default.patch"
;;
esac
# Leave the source directory
popd
# Make a build directory
mkdir "$FOLDER_NAME/build"
# Enter the build directory
pushd "$FOLDER_NAME/build"
# Configure the source
SED=sed                                 \
../configure --prefix=/usr              \
             --enable-languages=c,c++   \
             --disable-multilib         \
             --disable-bootstrap        \
             --with-system-zlib
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  ln -sv ../usr/bin/cpp /lib
  ln -sv gcc /usr/bin/cc
  install -v -dm755 /usr/lib/bfd-plugins
  ln -sfv ../../libexec/gcc/"$(gcc -dumpmachine)"/6.1.0/liblto_plugin.so \
          /usr/lib/bfd-plugins/
  # Apparently some files get misplaced, so put them in their place
  mkdir -pv /usr/share/gdb/auto-load/usr/lib
  mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
