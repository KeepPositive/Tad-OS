#! /bin/bash

## Start variables
NAME='setuptools'
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
./configure
# Build and install the configured sources
python2 setup.py install --optimize=1
python3 setup.py install --optimize=1
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
