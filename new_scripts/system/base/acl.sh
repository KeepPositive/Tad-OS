#! /bin/bash

## Start variables
NAME='acl'
EXTENSION='.src.tar.gz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test
sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" \
  libacl/__acl_to_any_text.c
# Configure the source
./configure --prefix=/usr    \
            --disable-static \
            --libexecdir=/usr/lib
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install install-dev install-lib
  chmod -v 755 /usr/lib/libacl.so
  mv -v /usr/lib/libacl.so.* /lib
  ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
