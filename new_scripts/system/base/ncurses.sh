#! /bin/bash

## Start variables
NAME='ncurses'
EXTENSION='.tar.gz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Configure the source
sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  mv -v /usr/lib/libncursesw.so.6* /lib
  ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) \
          /usr/lib/libncursesw.so
  for lib in ncurses form panel menu
  do
    rm -vf /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc /usr/lib/pkgconfig/${lib}.pc
  done
  rm -vf /usr/lib/libcursesw.so
  echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
  ln -sfv libncurses.so /usr/lib/libcurses.so
  # Install documentation
  mkdir -v "/usr/share/doc/$FOLDER_NAME"
  cp -v -R doc/* "/usr/share/doc/$FOLDER_NAME"
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
