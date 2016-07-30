#! /bin/bash

## Start variables
NAME='curl'
VERSION=$(date +%Y%m%d)
## End variables

## Start script
# Enter the source directory
pushd "$SOURCE_DIR/$NAME"
# Generate the configure file
./buildconf
# Configure the source
./configure --prefix=/usr    \
            --disable-static \
            --enable-threaded-resolver
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  cp -a docs docs-save
  rm -rf docs/examples/.deps

  find docs \( -name Makefile\* \
            -o -name \*.1       \
            -o -name \*.3 \)    \
            -exec rm {} \;
  install -v -d -m755 /usr/share/doc/curl-$VERSION
  cp -v -R docs/* /usr/share/doc/curl-$VERSION
  rm -rf docs
  mv -i docs-save doc
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
