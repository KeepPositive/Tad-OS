#! /bin/bash

## Start variables
NAME='firefox'
EXTENSION='.source.tar.xz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Configure the source
# Copy the premade config file
echo "$SCRIPT_DIR/firefox.conf"

cp ".$SCRIPT_DIR/firefox.conf" mozconfig
# Force compatability with GCC 6.1
sed -e '/#include/i\
    print OUT "#define _GLIBCXX_INCLUDE_NEXT_C_HEADERS\\n"\;' \
    -i nsprpub/config/make-system-wrappers.pl
sed -e '/#include/a\
    print OUT "#undef _GLIBCXX_INCLUDE_NEXT_C_HEADERS\\n"\;' \
    -i nsprpub/config/make-system-wrappers.pl
# Build using the configured sources
CXX='g++ -std=c++11' make -f client.mk
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make -f client.mk install INSTALL_SDK=
  chown -R 0:0 "/usr/lib/$FOLDER_NAME"
  mkdir -pv /usr/lib/mozilla/plugins
  ln -sfv ../../mozilla/plugins "/usr/lib/$FOLDER_NAME/browser"
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
