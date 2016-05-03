#! /bin/bash

# Enter one of the following types as an argument:
#   + 'proto' for X.Org protocol headers
#   + 'lib' for X.Org libraries
#   + 'app' for generic X.Org applications
#   + 'font' for standard X.Org fonts
TYPE=$1
PACKAGE_DIR="$START_DIR/packs"
PACK_FOLDER="$PACKAGE_DIR/$TYPE"

# Make a directory with the name of the download group
if [ ! -d "$PACK_FOLDER" ]; then
    mkdir "$PACK_FOLDER"
fi

# Enter the directory just created
pushd "$PACK_FOLDER"

# Using file names in the respective md5 file, download needed packages
grep -v '^#' "$START_DIR/sha256/$TYPE.sha256" | awk '{print $2}' | wget \
     --show-progress --no-clobber -c -i- \
     -B http://ftp.x.org/pub/individual/$TYPE/

# Exit the package directory
popd

