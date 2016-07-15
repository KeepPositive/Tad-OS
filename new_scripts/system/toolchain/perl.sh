#! /bin/bash

## Start variables
NAME='perl'
EXTENSION='.tar.bz2'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
VERSION=$(echo $FOLDER_NAME | sed -e "s/perl-//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Configure the source
sh Configure -des -Dprefix=/tools -Dlibs=-lm
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  cp -v perl cpan/podlators/pod2man /tools/bin
  mkdir -pv "/tools/lib/perl5/$VERSION"
  cp -Rv lib/* "/tools/lib/perl5/$VERSION"
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
